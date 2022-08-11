/// Exception, that occurs when message is invalid.
class InvalidMessageException implements Exception {
  /// Message, describing exception's explanation.
  final String message;

  /// Constructor for [InvalidMessageException].
  const InvalidMessageException(this.message);

  @override
  String toString() => 'InvalidMessageException(message: $message)';
}
