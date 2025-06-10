/// {@template breadcrumb}
/// Represents a breadcrumb, typically used for tracking events or errors.
/// {@endtemplate}
class Breadcrumb {
  /// {@macro breadcrumb}
  Breadcrumb({
    required this.message,
    this.category,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// The main message associated with the breadcrumb.
  final String message;

  /// An optional category for the breadcrumb, used for grouping or filtering.
  final String? category;

  /// Optional additional structured data associated with the breadcrumb.
  ///
  /// This can be used to store context-specific information.
  final Map<String, dynamic>? data;

  /// The timestamp indicating when the breadcrumb was created.
  ///
  /// Defaults to `DateTime.now()` if not provided.
  final DateTime timestamp;
}
