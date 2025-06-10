import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_eats_clone_application/application_bloc_observer.dart';

/// {@template bootstrap}
/// Performs essential initialization and setup for the Flutter application,
/// including error handling and running the main application widget.
///
/// - Ensures Flutter bindings are initialized.
/// - Sets up a global Flutter error handler (`FlutterError.onError`).
/// - Uses `runZonedGuarded` to catch asynchronous errors.
/// - Initializes a [BlocObserver] for BLoC state management errors.
/// - Allows for custom initialization logic via [onInitialize].
/// - Builds and runs the application widget provided by [applicationBuilder].
/// - Optionally reports errors using the provided [errorReporter].
/// {@endtemplate}
Future<void> bootstrap({
  required ApplicationBuilder applicationBuilder,
  Initializer? onInitialize,
  ErrorReporter? errorReporter,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
    errorReporter?.call(details.exception, details.stack ?? StackTrace.empty);
  };

  await runZonedGuarded(
    () async {
      Bloc.observer = ApplicationBlocObserver();
      await onInitialize?.call();
      runApp(await applicationBuilder());
    },
    (error, stack) {
      log('Error: $error', stackTrace: stack);
      errorReporter?.call(error, stack);
    },
  );
}

/// {@template application_builder}
/// Defines the signature for a function that provides the root application widget.
///
/// This function can be synchronous or asynchronous.
/// {@endtemplate}
typedef ApplicationBuilder = FutureOr<Widget> Function();

/// {@template error_reporter}
/// Callback signature for handling application-level errors.
///
/// [error] is the error object that was caught.
/// [stackTrace] is the stack trace associated with the error.
/// {@endtemplate}
typedef ErrorReporter = void Function(Object error, StackTrace stackTrace);

/// {@template initializer}
/// Callback signature for custom initialization tasks.
/// This function is called before the application widget is run.
/// {@endtemplate}
typedef Initializer = Future<void> Function();
