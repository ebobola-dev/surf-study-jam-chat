import 'package:flutter/foundation.dart';

/// Exception, that occurs in authorization process.
@immutable
class AuthException implements Exception {
  /// Message, describing exception's explanation.
  final String message;

  /// Constructor for [AuthException].
  const AuthException(this.message);

  @override
  String toString() => 'AuthException(message: $message)';
}
