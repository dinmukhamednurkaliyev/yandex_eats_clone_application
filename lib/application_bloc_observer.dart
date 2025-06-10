import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template application_bloc_observer}
/// Observes all BLoC errors and logs them with BLoC type, error, and stack trace.
/// {@endtemplate}
class ApplicationBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    developer.log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
