import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Performs essential initialization and setup for the Flutter application,
/// including error handling and running the main application widget.
Future<void> bootstrap({
  required FutureOr<Widget> Function() applicationBuilder,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      Bloc.observer = ApplicationBlocObserver();
      runApp(await applicationBuilder());
    },
    (error, stack) {
      log('Error: $error', stackTrace: stack);
    },
  );
}

/// Observes all BLoC errors and logs them with BLoC type, error, and stack trace.
class ApplicationBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
