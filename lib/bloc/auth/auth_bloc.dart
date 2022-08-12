import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_event.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_state.dart';
import 'package:surf_practice_chat_flutter/features/auth/exceptions/auth_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const _secureStorageKey = 'tokenDto';

  final _secureStorage = const FlutterSecureStorage();
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(NotAuthorizedState()) {
    on<ChangeLoginTextEvent>((event, emit) {
      if (state.runtimeType != NotAuthorizedState) return;
      final state_ = state as NotAuthorizedState;
      emit(state_.copyWith(loginTextInput: event.newLoginText));
    });

    on<ChangePasswordTextEvent>((event, emit) {
      if (state.runtimeType != NotAuthorizedState) return;
      final state_ = state as NotAuthorizedState;
      emit(state_.copyWith(passwordTextInput: event.newPasswordText));
    });

    on<ClearLoginTextEvent>((event, emit) {
      if (state.runtimeType != NotAuthorizedState) return;
      final state_ = state as NotAuthorizedState;
      emit(state_.copyWith(loginTextInput: ''));
    });

    on<ClearPasswordTextEvent>((event, emit) {
      if (state.runtimeType != NotAuthorizedState) return;
      final state_ = state as NotAuthorizedState;
      emit(state_.copyWith(passwordTextInput: ''));
    });

    on<TogglePasswordDisplayEvent>((event, emit) {
      if (state.runtimeType != NotAuthorizedState) return;
      final state_ = state as NotAuthorizedState;
      emit(state_.copyWith(showPassword: !state_.showPassword));
    });

    on<LoginEvent>((event, emit) async {
      if (state.runtimeType != NotAuthorizedState) return;
      final state_ = state as NotAuthorizedState;
      if (state_.authorizationInProgress) {
        //? return, if request is already started
        return;
      }
      emit(state_.copyWith(
        authorizationInProgress: true,
        authError: null,
        changeError: true,
      ));
      try {
        final token = await authRepository.signIn(
          login: state_.loginTextInput,
          password: state_.passwordTextInput,
        );
        await _secureStorage.write(key: _secureStorageKey, value: token.token);
        final me =
            await StudyJamClient().getAuthorizedClient(token.token).getUser();
        emit(AuthorizedState(
          token: token,
          me: me,
        ));
      } on AuthException catch (authError) {
        log('Bloc: error on update messages: $authError');
        emit(state_.copyWith(
          authError: authError,
          changeError: true,
          authorizationInProgress: false,
        ));
      }
    });

    on<LoginWithTokenEvent>((event, emit) async {
      if (state.runtimeType != NotAuthorizedState) return;
      final state_ = state as NotAuthorizedState;
      if (state_.authorizationInProgress) {
        //? return, if request is already started
        return;
      }
      emit(state_.copyWith(
        authorizationInProgress: true,
        authError: null,
        changeError: true,
      ));
      try {
        final me = await StudyJamClient()
            .getAuthorizedClient(event.token.token)
            .getUser();
        emit(AuthorizedState(
          token: event.token,
          me: me,
        ));
      } on AuthException catch (authError) {
        log('Bloc: error on update messages: $authError');
        emit(state_.copyWith(
          authError: authError,
          changeError: true,
          authorizationInProgress: false,
        ));
      }
    });

    _checkStorage();
  }

  Future<void> _checkStorage() async {
    String? token = await _secureStorage.read(key: _secureStorageKey);
    if (token != null) {
      add(LoginWithTokenEvent(TokenDto(token: token)));
    }
  }
}
