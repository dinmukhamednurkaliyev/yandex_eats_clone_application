import 'package:flutter/widgets.dart';
import 'package:yandex_eats_clone_application/source/source.dart';

/// {@template application_page}
/// A StatelessWidget that wraps the [ApplicationView].
/// {@endtemplate}
class ApplicationPage extends StatelessWidget {
  /// {@macro application_page}
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ApplicationView();
  }
}
