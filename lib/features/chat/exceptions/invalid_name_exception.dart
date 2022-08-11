/// Exception, that occurs when message is invalid.
class InvalidNameException implements Exception {
  /// Message, describing exception's explanation.
  final String message;

  /// Constructor for [InvalidNameException].
  const InvalidNameException(this.message);

  @override
  String toString() => 'InvalidNameException(message: $message)';
}
