import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_error_reporting/flutter_error_reporting.dart';
import 'package:flutter_logger/flutter_logger.dart';

/// {@template application_bloc_observer}
/// Observes all BLoC events, changes, and errors,
/// logging them using [ApplicationLogger] and reporting critical errors
/// via [ErrorReporterService].
/// {@endtemplate}
class ApplicationBlocObserver extends BlocObserver {
  /// {@macro application_bloc_observer}
  ///
  /// Requires an [errorReporterService] to delegate error reporting and breadcrumbs.
  const ApplicationBlocObserver({
    required ErrorReporterService errorReporterService,
  }) : _errorReporter = errorReporterService;

  /// The [ErrorReporterService] instance used to report errors and add breadcrumbs.
  final ErrorReporterService _errorReporter;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    ApplicationLogger.instance.debug(
      'onChange(${bloc.runtimeType}, Current: ${change.currentState.runtimeType}, Next: ${change.nextState.runtimeType})',
    );
    _errorReporter.addBreadcrumb(
      Breadcrumb(
        message: 'Bloc State Changed',
        category: 'bloc',
        data: {
          'bloc': bloc.runtimeType.toString(),
          'from_state': change.currentState.runtimeType.toString(),
          'to_state': change.nextState.runtimeType.toString(),
        },
      ),
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    ApplicationLogger.instance.debug('onClose(${bloc.runtimeType})');
    _errorReporter.addBreadcrumb(
      Breadcrumb(
        message: 'Bloc Closed',
        category: 'bloc',
        data: {'bloc': bloc.runtimeType.toString()},
      ),
    );
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    ApplicationLogger.instance.debug('onCreate(${bloc.runtimeType})');
    _errorReporter.addBreadcrumb(
      Breadcrumb(
        message: 'Bloc Created',
        category: 'bloc',
        data: {'bloc': bloc.runtimeType.toString()},
      ),
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    // 1. Log the error to the console using ApplicationLogger for development visibility.
    ApplicationLogger.instance.error(
      'onError(${bloc.runtimeType})',
      error: error,
      stackTrace: stackTrace,
    );

    // 2. Report the error to the external error reporting service.
    // This is where Sentry, Crashlytics, etc., will receive the error.
    _errorReporter.reportError(error, stackTrace);

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    ApplicationLogger.instance.debug(
      'onEvent(${bloc.runtimeType}, ${event.runtimeType})',
    );
    _errorReporter.addBreadcrumb(
      Breadcrumb(
        message: 'Bloc Event Dispatched',
        category: 'bloc',
        data: {
          'bloc': bloc.runtimeType.toString(),
          'event': event.runtimeType.toString(),
        },
      ),
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    ApplicationLogger.instance.debug(
      'onTransition(${bloc.runtimeType}, Event: ${transition.event.runtimeType}, Current: ${transition.currentState.runtimeType}, Next: ${transition.nextState.runtimeType})',
    );
    _errorReporter.addBreadcrumb(
      Breadcrumb(
        message: 'Bloc Transition',
        category: 'bloc',
        data: {
          'bloc': bloc.runtimeType.toString(),
          'event': transition.event.runtimeType.toString(),
          'from_state': transition.currentState.runtimeType.toString(),
          'to_state': transition.nextState.runtimeType.toString(),
        },
      ),
    );
  }
}
