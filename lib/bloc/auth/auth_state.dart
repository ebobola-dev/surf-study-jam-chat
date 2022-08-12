import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/features/auth/exceptions/auth_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

abstract class AuthState extends Equatable {}

class NotAuthorizedState extends AuthState {
  final String loginTextInput;
  final String passwordTextInput;
  final AuthException? authError;
  final bool showPassword;
  final bool authorizationInProgress;

  NotAuthorizedState({
    this.authError,
    this.loginTextInput = '',
    this.passwordTextInput = '',
    this.showPassword = false,
    this.authorizationInProgress = false,
  });

  @override
  List<Object?> get props => [
        loginTextInput,
        passwordTextInput,
        authError,
        showPassword,
        authorizationInProgress,
      ];

  bool get canLogin =>
      loginTextInput.isNotEmpty && passwordTextInput.isNotEmpty;

  NotAuthorizedState copyWith({
    String? loginTextInput,
    String? passwordTextInput,
    bool? showPassword,
    bool? authorizationInProgress,
    AuthException? authError,
    bool changeError = false,
  }) =>
      NotAuthorizedState(
        loginTextInput: loginTextInput ?? this.loginTextInput,
        passwordTextInput: passwordTextInput ?? this.passwordTextInput,
        authError: changeError ? authError : this.authError,
        showPassword: showPassword ?? this.showPassword,
        authorizationInProgress:
            authorizationInProgress ?? this.authorizationInProgress,
      );
}

class AuthorizedState extends AuthState {
  final TokenDto token;
  final StudyJamClient authorizedClient;
  final SjUserDto? me;

  AuthorizedState({
    required this.token,
    required this.authorizedClient,
    required this.me,
  });

  @override
  List<Object?> get props => [token, me, authorizedClient];
}
