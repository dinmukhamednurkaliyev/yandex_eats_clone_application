import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_error_reporting/flutter_error_reporting.dart';
import 'package:flutter_logger/flutter_logger.dart';

/// {@template application_builder}
/// Defines the signature for a function that provides the root application widget.
///
/// This function can return a [Widget] synchronously or a [Future<Widget>] asynchronously.
/// {@endtemplate}
typedef ApplicationBuilder = FutureOr<Widget> Function();

/// {@template initializer}
/// Callback signature for custom asynchronous initialization tasks.
///
/// This function is called before the main application widget is run.
/// {@endtemplate}
typedef Initializer = Future<void> Function();

/// {@template app_bootstrapper}
/// A class responsible for performing the essential initialization and setup
/// for a Flutter application.
///
/// This class encapsulates the core bootstrapping logic, including:
/// - Setting up global error handling mechanisms.
/// - Integrating with [BlocObserver] for BLoC state management observation.
/// - Providing a lifecycle hook for application-specific initializations.
/// - Running the main application widget.
///
/// This design promotes consistency and robustness across multiple Flutter
/// applications within a monorepo by centralizing the startup process.
/// {@endtemplate}
class ApplicationBootstrapper {
  /// {@macro app_bootstrapper}
  ///
  /// Requires an [errorReporterService] for error reporting and a [blocObserver]
  /// for BLoC-related monitoring.
  const ApplicationBootstrapper({
    required ErrorReporterService errorReporterService,
    required BlocObserver blocObserver,
  }) : _errorReporterService = errorReporterService,
       _blocObserver = blocObserver;

  /// The [ErrorReporterService] instance used for reporting errors to external services.
  final ErrorReporterService _errorReporterService;

  /// The [BlocObserver] instance used for observing BLoC state changes and events.
  final BlocObserver _blocObserver;

  /// Initiates the application bootstrapping process.
  ///
  /// This method performs the following steps in sequence:
  /// 1. Ensures Flutter bindings are initialized.
  /// 2. Sets up global error handlers for both Flutter framework errors
  ///    and unhandled asynchronous Dart errors.
  /// 3. Assigns the provided [BlocObserver] to [Bloc.observer].
  /// 4. Executes any custom, application-specific initialization logic
  ///    provided by [onInitialize].
  /// 5. Builds and runs the main application widget obtained from [applicationBuilder].
  ///
  /// - [applicationBuilder]: A function that returns the root application widget.
  /// - [onInitialize]: An optional callback for custom asynchronous
  ///   initialization tasks that run before [runApp].
  Future<void> run({
    required ApplicationBuilder applicationBuilder,
    Initializer? onInitialize,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      Logger.instance.error(
        'Caught Flutter framework error:',
        name: 'AppBootstrapper.FlutterError',
        stackTrace: details.stack,
      );
      _errorReporterService.reportError(
        details.exception,
        details.stack ?? StackTrace.empty,
      );
    };

    await runZonedGuarded(
      () async {
        Bloc.observer = _blocObserver;
        await onInitialize?.call();
        runApp(await applicationBuilder());
      },
      (error, stack) {
        Logger.instance.fatal(
          'Caught unhandled error in runZonedGuarded:',
          name: 'AppBootstrapper.UnhandledError',
          error: error,
          stackTrace: stack,
        );
        _errorReporterService.reportError(error, stack);
      },
    );
  }
}
