import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bootstrapper/flutter_bootstrapper.dart';
import 'package:flutter_error_reporting/source/source.dart';
import 'package:flutter_logger/flutter_logger.dart';
import 'package:yandex_eats_clone_application/application_bloc_observer.dart';
import 'package:yandex_eats_clone_application/source/source.dart';

Future<void> main() async {
  final ErrorReporterService errorReporterService = DebugErrorReporter();
  final blocObserver = ApplicationBlocObserver(
    errorReporterService: errorReporterService,
  );
  final applicationBootstrapper = ApplicationBootstrapper(
    errorReporterService: errorReporterService,
    blocObserver: blocObserver,
  );
  final Initializer initializer = () async {
    await errorReporterService.initialize(
      ErrorReporterOptions(enableInDebugMode: true),
    );
    await Firebase.initializeApp();
    Logger.instance.info(
      'Application-specific initializations complete.',
      name: 'Application.Main',
    );
  };
  final applicationBuilder = () {
    return const ApplicationPage();
  };

  await applicationBootstrapper.run(
    applicationBuilder: applicationBuilder,
    onInitialize: initializer,
  );
}
