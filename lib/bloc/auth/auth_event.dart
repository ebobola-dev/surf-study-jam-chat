import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';

@immutable
abstract class AuthEvent {}

//* from bloc
class LoginWithTokenEvent extends AuthEvent {
  final TokenDto token;
  LoginWithTokenEvent(this.token);
}
//*

class ChangeLoginTextEvent extends AuthEvent {
  final String newLoginText;
  ChangeLoginTextEvent(this.newLoginText);
}

class ChangePasswordTextEvent extends AuthEvent {
  final String newPasswordText;
  ChangePasswordTextEvent(this.newPasswordText);
}

class ClearLoginTextEvent extends AuthEvent {}

class ClearPasswordTextEvent extends AuthEvent {}

class TogglePasswordDisplayEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {}
