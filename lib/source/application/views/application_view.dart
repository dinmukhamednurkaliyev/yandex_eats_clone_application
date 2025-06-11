import 'package:flutter/material.dart';
import 'package:yandex_eats_clone_application/source/source.dart';

/// {@template application_view}
/// The root widget of the application.
/// {@endtemplate}
class ApplicationView extends StatelessWidget {
  /// {@macro application_view}
  const ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AuthorizationPage());
  }
}
