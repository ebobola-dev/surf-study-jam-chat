import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_event.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_state.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';

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
      emit(state_.copyWith(authorizationInProgress: true));
      try {
        final token = await authRepository.signIn(
          login: state_.loginTextInput,
          password: state_.passwordTextInput,
        );
        emit(AuthorizedState(token: token));
      } catch (authError) {
        final List<String> newErrorsList = List.from(state_.authErrors)
          ..add(authError.toString());
        emit(state_.copyWith(authErrors: newErrorsList));
      }
    });
  }
}
