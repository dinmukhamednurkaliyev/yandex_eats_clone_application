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
/// conditional on `kDebugMode`.
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
  /// if `kDebugMode` is true.
  @override
  void addBreadcrumb(Breadcrumb breadcrumb) {
    if (kDebugMode) {
      _breadcrumbs.add(breadcrumb);
      developer.log(
        'Added breadcrumb: ${breadcrumb.message}',
        name: 'flutter_error_reporting.breadcrumb',
      );
    }
  }

  /// Logs a custom [message] to the console with its [severity] and optional [data]
  /// if `kDebugMode` is true.
  ///
  /// The log level used by `developer.log` is derived from the [Severity] enum.
  @override
  void captureMessage(
    String message, {
    Severity severity = Severity.info,
    Map<String, dynamic>? data,
  }) {
    if (kDebugMode) {
      developer.log(
        'Captured Message [${severity.name.toUpperCase()}]: $message',
        name: 'flutter_error_reporting.message',
        level: severity.index * 1000,
        error: data,
      );
    }
  }

  /// Clears all stored breadcrumbs from the internal list and logs the action
  /// to the console if `kDebugMode` is true.
  @override
  void clearBreadcrumbs() {
    if (kDebugMode) {
      _breadcrumbs.clear();
      developer.log(
        'Breadcrumbs cleared.',
        name: 'flutter_error_reporting.breadcrumb',
      );
    }
  }

  /// Clears all stored custom contexts and tags from the internal stores
  /// and logs the action to the console if `kDebugMode` is true.
  @override
  void clearContextsAndTags() {
    if (kDebugMode) {
      _contexts.clear();
      _tags.clear();
      developer.log(
        'All contexts and tags cleared.',
        name: 'flutter_error_reporting.context',
      );
    }
  }

  /// Logs the initialization of the debug reporter and the provided [options]
  /// to the console if `kDebugMode` is true.
  ///
  /// This implementation does not perform any complex setup beyond logging.
  @override
  Future<void> initialize(ErrorReporterOptions options) async {
    if (kDebugMode) {
      developer.log(
        'DebugErrorReporter initialized. Options: $options',
        name: 'flutter_error_reporting.init',
      );
    }
  }

  /// Removes a custom context identified by [key] from the internal store
  /// and logs the action to the console if `kDebugMode` is true.
  @override
  void removeContext(String key) {
    if (kDebugMode) {
      _contexts.remove(key);
      developer.log(
        'Context "$key" removed.',
        name: 'flutter_error_reporting.context',
      );
    }
  }

  /// Removes a tag identified by [key] from the internal store
  /// and logs the action to the console if `kDebugMode` is true.
  @override
  void removeTag(String key) {
    if (kDebugMode) {
      _tags.remove(key);
      developer.log('Tag "$key" removed.', name: 'flutter_error_reporting.tag');
    }
  }

  /// Reports an [error] and its [stackTrace] to the console if `kDebugMode` is true.
  ///
  /// Also logs any accumulated breadcrumbs, contexts, tags, and the current
  /// user information from the internal stores to aid in debugging the reported error.
  /// All logged information is prefixed with `flutter_error_reporting`.
  @override
  void reportError(Object error, StackTrace? stackTrace) {
    if (kDebugMode) {
      developer.log(
        '--- ERROR REPORTED ---',
        name: 'flutter_error_reporting.error',
        error: error,
        stackTrace: stackTrace,
      );
      if (_breadcrumbs.isNotEmpty) {
        developer.log(
          'Breadcrumbs:\n${_breadcrumbs.map((breadcrumb) => '- $breadcrumb').join('\n')}',
          name: 'flutter_error_reporting.breadcrumbs',
        );
      }
      if (_contexts.isNotEmpty) {
        developer.log(
          'Contexts:\n${_contexts.entries.map((entries) => '- ${entries.key}: ${entries.value}').join('\n')}',
          name: 'flutter_error_reporting.contexts',
        );
      }
      if (_tags.isNotEmpty) {
        developer.log(
          'Tags:\n${_tags.entries.map((entries) => '- ${entries.key}: ${entries.value}').join('\n')}',
          name: 'flutter_error_reporting.tags',
        );
      }
      if (_currentUser != null) {
        developer.log(
          'User: $_currentUser',
          name: 'flutter_error_reporting.user',
        );
      }
      developer.log(
        '--------------------',
        name: 'flutter_error_reporting.error',
      );
    }
  }

  /// Sets a custom [context] (a map of key-value pairs) associated with [key]
  /// in the internal store and logs it to the console if `kDebugMode` is true.
  @override
  void setContext(String key, Map<String, dynamic> context) {
    if (kDebugMode) {
      _contexts[key] = context;
      developer.log(
        'Context "$key" set: $context',
        name: 'flutter_error_reporting.context',
      );
    }
  }

  /// Sets a tag (a key-value string pair) in the internal store and logs it
  /// to the console if `kDebugMode` is true.
  @override
  void setTag(String key, String value) {
    if (kDebugMode) {
      _tags[key] = value;
      developer.log(
        'Tag "$key" set: $value',
        name: 'flutter_error_reporting.tag',
      );
    }
  }

  /// Sets the current [ErrorUser] in the internal store and logs the user information
  /// (or that it was cleared if [user] is null) to the console if `kDebugMode` is true.
  @override
  void setUser(ErrorUser? user) {
    if (kDebugMode) {
      _currentUser = user;
      developer.log(
        'User context set: ${user?.toString() ?? 'cleared'}',
        name: 'flutter_error_reporting.user',
      );
    }
  }
}
