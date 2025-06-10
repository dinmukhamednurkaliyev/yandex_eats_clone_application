import 'package:flutter_error_reporting/source/source.dart';

/// {@template error_reporter_service}
/// An abstract class defining the contract for error reporting services.
///
/// Implementations of this class are responsible for handling and
/// reporting errors that occur within the application.
/// {@endtemplate}
abstract class ErrorReporterService {
  /// Adds a [Breadcrumb] to the current error reporting scope.
  ///
  /// Breadcrumbs are used to record a trail of events that occurred
  /// before an error.
  void addBreadcrumb(Breadcrumb breadcrumb);

  /// Captures and reports a custom message.
  ///
  /// [message] is the string message to report.
  /// [severity] indicates the severity level of the message (e.g., info, warning, error).
  /// [data] is optional additional structured data to associate with the message.
  void captureMessage(
    String message, {
    Severity severity = Severity.info,
    Map<String, dynamic>? data,
  });

  /// Clears all [Breadcrumb]s from the current error reporting scope.
  void clearBreadcrumbs();

  /// Clears all custom contexts and tags from the current error reporting scope.
  void clearContextsAndTags();

  /// Initializes the error reporting service.
  ///
  /// This method can be overridden by implementations to perform
  /// any necessary setup, such as configuring an external service.
  Future<void> initialize(ErrorReporterOptions options);

  /// Removes a custom context from the current error reporting scope.
  ///
  /// [key] is the identifier of the context to remove.
  void removeContext(String key);

  /// Removes a tag from the current error reporting scope.
  ///
  /// [key] is the identifier of the tag to remove.
  void removeTag(String key);

  /// Reports an error.
  ///
  /// [error] is the error object that was caught.
  /// [stackTrace] is the stack trace associated with the error, if available.
  void reportError(Object error, StackTrace? stackTrace);

  /// Sets a custom context for the current error reporting scope.
  ///
  /// [key] is the identifier for the context.
  /// [context] is a map of key-value pairs representing the context data.
  /// This can be used to add arbitrary structured data that might be useful
  /// for debugging.
  void setContext(String key, Map<String, dynamic> context);

  /// Sets a tag for the current error reporting scope.
  ///
  /// [key] is the identifier for the tag.
  /// [value] is the string value of the tag.
  /// Tags are simple key-value strings that can be used for filtering
  /// or categorizing errors.
  void setTag(String key, String value);

  /// Sets the [ErrorUser] for the current error reporting scope.
  ///
  /// Providing user information can help in diagnosis and elimination of errors.
  void setUser(ErrorUser? user);
}
