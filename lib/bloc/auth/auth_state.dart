import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';

abstract class AuthState extends Equatable {}

class NotAuthorizedState extends AuthState {
  final String loginTextInput;
  final String passwordTextInput;
  final List<String> authErrors;
  final bool showPassword;
  final bool authorizationInProgress;

  NotAuthorizedState({
    this.loginTextInput = '',
    this.passwordTextInput = '',
    this.authErrors = const [],
    this.showPassword = false,
    this.authorizationInProgress = false,
  });

  @override
  List<Object> get props => [
        loginTextInput,
        passwordTextInput,
        authErrors,
        showPassword,
        authorizationInProgress,
      ];

  bool get canLogin =>
      loginTextInput.isNotEmpty && passwordTextInput.isNotEmpty;

  NotAuthorizedState copyWith({
    String? loginTextInput,
    String? passwordTextInput,
    List<String>? authErrors,
    bool? showPassword,
    bool? authorizationInProgress,
  }) =>
      NotAuthorizedState(
        loginTextInput: loginTextInput ?? this.loginTextInput,
        passwordTextInput: passwordTextInput ?? this.passwordTextInput,
        authErrors: authErrors ?? this.authErrors,
        showPassword: showPassword ?? this.showPassword,
        authorizationInProgress:
            authorizationInProgress ?? this.authorizationInProgress,
      );
}

class AuthorizedState extends AuthState {
  final TokenDto token;

  AuthorizedState({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}
