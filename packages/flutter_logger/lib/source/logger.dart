import 'dart:developer' as developer;

import 'package:flutter_logger/source/level.dart';

/// {@template application_logger}
/// A singleton logger for the application providing structured logging.
///
/// This logger uses `dart:developer.log` internally, allowing for granular
/// control over log messages, including log levels, associated errors,
/// stack traces, and custom log names for filtering in IDEs.
/// {@endtemplate}
class Logger {
  /// Private constructor for the singleton pattern.
  const Logger._internal();

  /// The singleton instance of [Logger].
  static const Logger _instance = Logger._internal();

  /// Returns the singleton instance of [Logger].
  static Logger get instance => _instance;

  /// Logs a message at the [Level.debug] level.
  ///
  /// Use this for fine-grained informational events that are most useful to
  /// debug an application.
  ///
  /// - [message]: The primary text to be logged.
  /// - [name]: An optional name for the log entry, useful for filtering in IDEs.
  /// - [error]: An optional error object associated with this log.
  /// - [stackTrace]: An optional stack trace associated with this log.
  void debug(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      level: Level.debug,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a message at the [Level.error] level.
  ///
  /// Use this for error events that might still allow the application to
  /// continue running.
  ///
  /// - [message]: The primary text to be logged.
  /// - [name]: An optional name for the log entry.
  /// - [error]: An optional error object associated with this log.
  /// - [stackTrace]: An optional stack trace associated with this log.
  void error(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      level: Level.error,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a message at the [Level.fatal] level.
  ///
  /// Use this for very severe error events that will presumably lead the
  /// application to abort.
  ///
  /// - [message]: The primary text to be logged.
  /// - [name]: An optional name for the log entry.
  /// - [error]: An optional error object associated with the log.
  /// - [stackTrace]: An optional stack trace associated with the log.
  void fatal(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      level: Level.fatal,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a message at the [Level.info] level.
  ///
  /// Use this for informational messages that highlight the progress of the
  /// application at a coarse-grained level.
  ///
  /// - [message]: The primary text to be logged.
  /// - [name]: An optional name for the log entry.
  /// - [error]: An optional error object associated with this log.
  /// - [stackTrace]: An optional stack trace associated with this log.
  void info(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      level: Level.info,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a message at the [Level.warning] level.
  ///
  /// Use this for potentially harmful situations.
  ///
  /// - [message]: The primary text to be logged.
  /// - [name]: An optional name for the log entry.
  /// - [error]: An optional error object associated with this log.
  /// - [stackTrace]: An optional stack trace associated with this log.
  void warn(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      level: Level.warning,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Internal method to perform the actual logging using `dart:developer.log`.
  ///
  /// All public logging methods delegate to this private method to ensure
  /// consistent logging behavior across all levels.
  void _log(
    String message, {
    required Level level,
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final String prefix = '[${level.toString().split('.').last.toUpperCase()}]';
    developer.log(
      '$prefix $message',
      time: DateTime.now(),
      level: level.index * 1000,
      name: name ?? 'Application',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
