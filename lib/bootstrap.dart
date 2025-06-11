import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_error_reporting/flutter_error_reporting.dart';
import 'package:flutter_logger/source/application_logger.dart';
import 'package:yandex_eats_clone_application/application_bloc_observer.dart';

/// {@template bootstrap}
/// Performs essential initialization and setup for the Flutter application,
/// including error handling and running the main application widget.
///
/// - Ensures Flutter bindings are initialized first.
/// - Sets up a global Flutter error handler (`FlutterError.onError`)
///   and a `runZonedGuarded` block to catch synchronous and asynchronous errors.
/// - Initializes the [BlocObserver] for BLoC state management, delegating
///   error reporting and breadcrumb functionality to the provided [errorReporterService].
/// - Allows for custom initialization logic via [onInitialize] callback.
/// - Builds and runs the main application widget provided by [applicationBuilder].
/// {@endtemplate}
Future<void> bootstrap({
  required ApplicationBuilder applicationBuilder,
  required ErrorReporterService errorReporterService,
  Initializer? onInitialize,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    ApplicationLogger.instance.error(
      'Caught Flutter framework error:',
      error: details.exception,
      stackTrace: details.stack,
    );
    errorReporterService.reportError(
      details.exception,
      details.stack ?? StackTrace.empty,
    );
  };

  await runZonedGuarded(
    () async {
      Bloc.observer = ApplicationBlocObserver(
        errorReporterService: errorReporterService,
      );
      await onInitialize?.call();
      runApp(await applicationBuilder());
    },
    (error, stack) {
      ApplicationLogger.instance.fatal(
        'Caught unhandled error in runZonedGuarded:',
        error: error,
        stackTrace: stack,
      );
      errorReporterService.reportError(error, stack);
    },
  );
}

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
