import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {}

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
