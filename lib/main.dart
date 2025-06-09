import 'package:yandex_eats_clone_application/bootstrap.dart';
import 'package:yandex_eats_clone_application/source/source.dart';

Future<void> main() async {
  await bootstrap(
    applicationBuilder: () {
      return const AuthorizationPage();
    },
  );
}
