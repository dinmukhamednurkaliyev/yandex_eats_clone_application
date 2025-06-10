import 'package:flutter_error_reporting/source/source.dart';
import 'package:yandex_eats_clone_application/bootstrap.dart';
import 'package:yandex_eats_clone_application/source/source.dart';

Future<void> main() async {
  final ErrorReporterService errorReporterService = DebugErrorReporter();
  final Initializer initializer = () async {
    await errorReporterService.initialize(
      ErrorReporterOptions(enableInDebugMode: true),
    );
  };
  final applicationBuilder = () {
    return const AuthorizationPage();
  };

  await bootstrap(
    applicationBuilder: applicationBuilder,
    onInitialize: initializer,
    errorReporter: errorReporterService.reportError,
  );
}
