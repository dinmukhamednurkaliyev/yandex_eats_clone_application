import 'dart:developer' as developer;

import 'package:flutter_logger/source/source.dart';

/// {@template application_logger}
/// A singleton logger for the application.
///
/// Provides methods to log messages at different severity levels.
/// {@endtemplate}
class ApplicationLogger {
  /// {@macro application_logger}
  const ApplicationLogger._internal();

  static const ApplicationLogger _instance = ApplicationLogger._internal();

  /// Returns the singleton instance of [ApplicationLogger].
  static ApplicationLogger get instance => _instance;

  /// Logs a message at the [Level.debug] level.
  ///
  /// Use this for fine-grained informational events that are most useful to
  /// debug an application.
  ///
  /// - [message]: The message to log.
  /// - [error]: An optional error object associated with the log.
  /// - [stackTrace]: An optional stack trace associated with the error.
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, level: Level.debug, error: error, stackTrace: stackTrace);
  }

  /// Logs a message at the [Level.error] level.
  ///
  /// Use this for error events that might still allow the application to
  /// continue running.
  ///
  /// - [message]: The message to log.
  /// - [error]: An optional error object associated with the log.
  /// - [stackTrace]: An optional stack trace associated with the error.
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, level: Level.error, error: error, stackTrace: stackTrace);
  }

  /// Logs a message at the [Level.fatal] level.
  ///
  /// Use this for very severe error events that will presumably lead the
  /// application to abort.
  ///
  /// - [message]: The message to log.
  /// - [error]: An optional error object associated with the log.
  /// - [stackTrace]: An optional stack trace associated with the error.
  void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, level: Level.fatal, error: error, stackTrace: stackTrace);
  }

  /// Logs a message at the [Level.info] level.
  ///
  /// Use this for informational messages that highlight the progress of the
  /// application at coarse-grained level.
  ///
  /// - [message]: The message to log.
  /// - [error]: An optional error object associated with the log.
  /// - [stackTrace]: An optional stack trace associated with the error.
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, level: Level.info, error: error, stackTrace: stackTrace);
  }

  /// Logs a message at the [Level.warning] level.
  ///
  /// Use this for potentially harmful situations.
  ///
  /// - [message]: The message to log.
  /// - [error]: An optional error object associated with the log.
  /// - [stackTrace]: An optional stack trace associated with the error.
  void warn(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, level: Level.warning, error: error, stackTrace: stackTrace);
  }

  void _log(
    String message, {
    required Level level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final String prefix = '[${level.toString().split('.').last.toUpperCase()}]';
    developer.log(
      '$prefix $message',
      time: DateTime.now(),
      level: level.index * 1000,
      name: 'Application',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
