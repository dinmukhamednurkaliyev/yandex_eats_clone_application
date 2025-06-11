/// {@template level}
/// Defines the level of an event or message.
/// {@endtemplate}
enum Level {
  /// {@template level.debug}
  /// Designates fine-grained informational events that are most useful to
  /// debug an application.
  /// {@endtemplate}
  debug,

  /// {@template level.info}
  /// Designates informational messages that highlight the progress of the
  /// application at a coarse-grained level.
  /// {@endtemplate}
  info,

  /// {@template level.warning}
  /// Designates potentially harmful situations.
  /// {@endtemplate}
  warning,

  /// {@template level.error}
  /// Designates error events that might still allow the application to
  /// continue running.
  /// {@endtemplate}
  error,

  /// {@template level.fatal}
  /// Designates very severe error events that will presumably lead the
  /// application to abort.
  /// {@endtemplate}
}
