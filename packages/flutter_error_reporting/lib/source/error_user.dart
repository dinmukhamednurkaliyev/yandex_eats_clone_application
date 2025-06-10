/// {@template error_user}
/// Represents a user associated with an error report.
///
/// This class holds identifiable information about the user
/// who experienced an error, which can be helpful for debugging
/// and support.
/// {@endtemplate}
class ErrorUser {
  /// {@macro error_user}
  ErrorUser({required this.id, this.email, this.username, this.ipAddress});

  /// A unique identifier for the user.
  final String id;

  /// The user's email address, if available.
  final String? email;

  /// The user's username, if available.
  final String? username;

  /// The user's IP address at the time of the error, if available.
  final String? ipAddress;
}
