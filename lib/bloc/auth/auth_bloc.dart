import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_event.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_state.dart';
import 'package:surf_practice_chat_flutter/features/auth/exceptions/auth_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
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
  }
}
