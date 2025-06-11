import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_error_reporting/source/source.dart';

/// {@template debug_error_reporter}
/// A debug implementation of [ErrorReporterService] that prints errors,
/// messages, breadcrumbs, and other contextual information to the console.
///
/// This reporter is intended for use during development (when `kDebugMode` is true).
/// It utilizes `dart:developer.log` for output, making it easy to inspect
/// reported data directly in the development console. All operations are
/// conditional on `kDebugMode`. Each log entry is assigned a [Level] level
/// for improved filtering and understanding.
/// {@endtemplate}
class DebugErrorReporter implements ErrorReporterService {
  /// {@macro debug_error_reporter}
  DebugErrorReporter();

  // A simple in-memory store for debug breadcrumbs, contexts, and tags.
  // Note: For a real error reporter, these would be managed by the
  // underlying SDK (e.g., Sentry's scope). Here, it's just for display.
  final List<Breadcrumb> _breadcrumbs = [];
  final Map<String, Map<String, dynamic>> _contexts = {};
  final Map<String, String> _tags = {};
  ErrorUser? _currentUser;

  /// Adds a [Breadcrumb] to an internal list and logs its message to the console
  /// at [Level.debug] level if `kDebugMode` is true.
  @override
  void addBreadcrumb(Breadcrumb breadcrumb) {
    _breadcrumbs.add(
      breadcrumb,
    ); // Add regardless of debug mode, as list accumulates data
    _log(
      'Added breadcrumb: ${breadcrumb.message}',
      name: 'flutter_error_reporting.breadcrumb',
      level: Level.debug,
    );
  }

  /// Logs a custom [message] to the console with its [level] and optional [data]
  /// if `kDebugMode` is true.
  ///
  /// The log level used by `developer.log` is derived from the [Level] enum.
  @override
  void captureMessage(
    String message, {
    Level level = Level.info,
    Map<String, dynamic>? data,
  }) {
    _log(
      'Captured Message [${level.name.toUpperCase()}]: $message',
      name: 'flutter_error_reporting.message',
      level: level,
      error: data,
    );
  }

  /// Clears all stored breadcrumbs from the internal list and logs the action
  /// at [Level.debug] level to the console if `kDebugMode` is true.
  @override
  void clearBreadcrumbs() {
    _breadcrumbs.clear();
    _log(
      'Breadcrumbs cleared.',
      name: 'flutter_error_reporting.breadcrumb',
      level: Level.debug,
    );
  }

  /// Clears all stored custom contexts and tags from the internal stores
  /// and logs the action at [Level.debug] level to the console if `kDebugMode` is true.
  @override
  void clearContextsAndTags() {
    _contexts.clear();
    _tags.clear();
    _log(
      'All contexts and tags cleared.',
      name: 'flutter_error_reporting.context',
      level: Level.debug,
    );
  }

  /// Logs the initialization of the debug reporter and the provided [options]
  /// at [Level.info] level to the console if `kDebugMode` is true.
  ///
  /// This implementation does not perform any complex setup beyond logging.
  @override
  Future<void> initialize(ErrorReporterOptions options) async {
    _log(
      'DebugErrorReporter initialized. Options: $options',
      name: 'flutter_error_reporting.init',
      level: Level.info,
    );
  }

  /// Removes a custom context identified by [key] from the internal store
  /// and logs the action at [Level.debug] level to the console if `kDebugMode` is true.
  @override
  void removeContext(String key) {
    _contexts.remove(key);
    _log(
      'Context "$key" removed.',
      name: 'flutter_error_reporting.context',
      level: Level.debug,
    );
  }

  /// Removes a tag identified by [key] from the internal store
  /// and logs the action at [Level.debug] level to the console if `kDebugMode` is true.
  @override
  void removeTag(String key) {
    _tags.remove(key);
    _log(
      'Tag "$key" removed.',
      name: 'flutter_error_reporting.tag',
      level: Level.debug,
    );
  }

  /// Reports an [error] and its [stackTrace] to the console at [Level.error] level
  /// if `kDebugMode` is true.
  ///
  /// Also logs any accumulated breadcrumbs, contexts, tags, and the current
  /// user information from the internal stores to aid in debugging the reported error.
  /// All logged information is prefixed with `flutter_error_reporting`.
  @override
  void reportError(Object error, StackTrace? stackTrace) {
    _log(
      '--- ERROR REPORTED ---',
      name: 'flutter_error_reporting.error',
      error: error,
      stackTrace: stackTrace,
      level: Level.error,
    );
    if (_breadcrumbs.isNotEmpty) {
      _log(
        'Breadcrumbs:\n${_breadcrumbs.map((breadcrumb) => '- $breadcrumb').join('\n')}',
        name: 'flutter_error_reporting.breadcrumbs',
        level: Level.debug,
      );
    }
    if (_contexts.isNotEmpty) {
      _log(
        'Contexts:\n${_contexts.entries.map((entries) => '- ${entries.key}: ${entries.value}').join('\n')}',
        name: 'flutter_error_reporting.contexts',
        level: Level.debug,
      );
    }
    if (_tags.isNotEmpty) {
      _log(
        'Tags:\n${_tags.entries.map((entries) => '- ${entries.key}: ${entries.value}').join('\n')}',
        name: 'flutter_error_reporting.tags',
        level: Level.debug,
      );
    }
    if (_currentUser != null) {
      _log(
        'User: $_currentUser',
        name: 'flutter_error_reporting.user',
        level: Level.info,
      );
    }
    _log(
      '--------------------',
      name: 'flutter_error_reporting.error',
      level: Level.error,
    );
  }

  /// Sets a custom [context] (a map of key-value pairs) associated with [key]
  /// in the internal store and logs it at [Level.debug] level to the console
  /// if `kDebugMode` is true.
  @override
  void setContext(String key, Map<String, dynamic> context) {
    _contexts[key] = context;
    _log(
      'Context "$key" set: $context',
      name: 'flutter_error_reporting.context',
      level: Level.debug,
    );
  }

  /// Sets a tag (a key-value string pair) in the internal store and logs it
  /// at [Level.debug] level to the console if `kDebugMode` is true.
  @override
  void setTag(String key, String value) {
    _tags[key] = value;
    _log(
      'Tag "$key" set: $value',
      name: 'flutter_error_reporting.tag',
      level: Level.debug,
    );
  }

  /// Sets the current [ErrorUser] in the internal store and logs the user information
  /// (or that it was cleared if [user] is null) at [Level.info] level to the console
  /// if `kDebugMode` is true.
  @override
  void setUser(ErrorUser? user) {
    _currentUser = user;
    _log(
      'User context set: ${user?.toString() ?? 'cleared'}',
      name: 'flutter_error_reporting.user',
      level: Level.info,
    );
  }

  /// Internal method to perform the actual logging using `dart:developer.log`.
  ///
  /// This method encapsulates the `kDebugMode` check and delegates to `developer.log`.
  /// It formats the message with a severity prefix and includes the current timestamp.
  void _log(
    String message, {
    required String name,
    required Level level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final String prefix =
          '[${level.toString().split('.').last.toUpperCase()}]';
      developer.log(
        '$prefix $message',
        name: name,
        level: level.index * 1000,
        time: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
