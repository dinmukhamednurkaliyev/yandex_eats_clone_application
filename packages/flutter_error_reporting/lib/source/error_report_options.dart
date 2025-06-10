import 'package:flutter_error_reporting/source/source.dart';

/// {@template error_reporter_options}
/// Configuration options for the [ErrorReporterService].
///
/// This class allows customizing the behavior of the error reporting
/// service, such as enabling/disabling reporting in debug mode or
/// ignoring specific error types.
/// {@endtemplate}
class ErrorReporterOptions {
  /// {@macro error_reporter_options}
  ErrorReporterOptions({
    this.enableInDebugMode = false,
    this.ignoredErrors = const [],
  });

  /// Whether error reporting should be enabled when the application is
  /// running in debug mode. Defaults to `false`.
  final bool enableInDebugMode;

  /// A list of error types that should be ignored by the reporter.
  final List<Type> ignoredErrors;
}
