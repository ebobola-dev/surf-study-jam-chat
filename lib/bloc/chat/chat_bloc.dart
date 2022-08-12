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

    on<AttachImage>((event, emit) {
      if (state.attachedImages.map((i) => i).contains(event.newImageUrl)) {
        //* return, if image already attached
        return;
      }
      final newImageList = List<String>.from(state.attachedImages)
        ..add(event.newImageUrl);
      emit(state.copyWith(attachedImages: newImageList));
    });

    on<DetachImage>((event, emit) {
      emit(state.copyWith(
        attachedImages:
            state.attachedImages.where((i) => i != event.imagePath).toList(),
      ));
    });

    on<DetachAllImages>((event, emit) {
      emit(state.copyWith(
        attachedImages: const [],
      ));
    });

    on<AttachGeolocation>((event, emit) {
      emit(state.copyWith(
        attachedGeolocation: event.geolocation,
        changeAttachedGeolocation: true,
      ));
    });

    on<DetachGeolocation>((event, emit) {
      emit(state.copyWith(
        attachedGeolocation: null,
        changeAttachedGeolocation: true,
      ));
    });

    on<DetachAll>((event, emit) {
      emit(state.copyWith(
        attachedImages: const [],
        attachedGeolocation: null,
        changeAttachedGeolocation: true,
      ));
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
      emit(state.copyWith(
        updating: true,
        error: null,
        changeError: true,
      ));
      try {
        final messages = await chatRepository.sendMessage(
          message: state.messageField,
          location: state.attachedGeolocation,
          imageUrls: state.imagesAttached ? state.attachedImages : null,
        );
        emit(state.copyWith(
          messages: messages,
          attachedGeolocation: null,
          attachedImages: const [],
          changeAttachedGeolocation: true,
          updating: false,
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
