import 'package:flutter/foundation.dart';
import 'package:yandex_eats_clone_application/bootstrap.dart';
import 'package:yandex_eats_clone_application/source/source.dart';

Future<void> main() async {
  await bootstrap(
    applicationBuilder: () {
      return const AuthorizationPage();
    },
    onInitialize: () async {},
    errorReporter: _reportError,
  );
}

void _reportError(Object error, StackTrace stackTrace) {
  debugPrint('--- Error reported to external service ---');
  debugPrint('Error: $error');
  debugPrint('StackTrace: $stackTrace');
  debugPrint('-----------------------------------------');
}
