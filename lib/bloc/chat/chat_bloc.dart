import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_event.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_state.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final IChatRepository chatRepository;
  ChatBloc({required this.chatRepository}) : super(const ChatState()) {
    on<ChangeMessageFieldEvent>((event, emit) {
      emit(state.copyWith(messageField: event.newMessageFieldText));
    });

    on<ClearMessageFieldEvent>((event, emit) {
      emit(state.copyWith(messageField: ''));
    });

    on<UpdateMessagesEvent>((event, emit) async {
      if (state.updating) {
        //? return if request already started
        return;
      }
      emit(state.copyWith(
        updating: true,
        error: null,
        changeError: true,
      ));
      try {
        final messages = await chatRepository.getMessages();
        emit(state.copyWith(
          messages: messages,
          updating: false,
        ));
      } catch (err) {
        log('Bloc: error on update messages: $err');
        emit(state.copyWith(
          error: err.toString(),
          changeError: true,
          updating: false,
        ));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        final messages = await chatRepository.sendMessage(state.messageField);
        emit(state.copyWith(
          messages: messages,
        ));
      } catch (err) {
        log('Bloc: error on send message: $err');
        emit(state.copyWith(
          error: err.toString(),
          changeError: true,
          updating: false,
        ));
      }
    });
  }
}
