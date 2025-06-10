import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Performs essential initialization and setup for the Flutter application,
/// including error handling and running the main application widget.
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

/// Defines the signature for a function that provides the root application widget.
typedef ApplicationBuilder = FutureOr<Widget> Function();

/// Callback signature for handling application-level errors.
typedef ErrorReporter = void Function(Object error, StackTrace stackTrace);

/// Callback signature for custom initialization tasks.
typedef Initializer = Future<void> Function();

/// Observes all BLoC errors and logs them with BLoC type, error, and stack trace.
class ApplicationBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
