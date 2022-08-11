/// Exception, that occurs when message is invalid.
class UserNotFoundException implements Exception {
  /// Message, describing exception's explanation.
  final String message;

  /// Constructor for [UserNotFoundException].
  const UserNotFoundException(this.message);

  @override
  String toString() => 'UserNotFoundException(message: $message)';
}
