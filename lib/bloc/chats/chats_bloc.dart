import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_event.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_state.dart';
import 'package:surf_practice_chat_flutter/features/chats/repository/chats_repositoty.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatsRepository chatsRepository;
  ChatsBloc({required this.chatsRepository}) : super(const ChatsState()) {
    on<UpdateChatsEvent>((event, emit) async {
      if (state.updating) return;
      emit(state.copyWith(
        updating: true,
        error: null,
        changeError: true,
      ));
      try {
        final chats = await chatsRepository.getChats();
        emit(state.copyWith(
          chats: chats,
          updating: false,
        ));
      } catch (err) {
        emit(state.copyWith(
          updating: false,
          error: err.toString(),
          changeError: true,
        ));
      }
    });

    on<CreateChatEvent>((event, emit) async {
      emit(state.copyWith(
        updating: true,
        error: null,
        changeError: true,
      ));
      try {
        final chats = await chatsRepository.createChat(
          name: event.name,
          description: event.description,
          avatar: event.avatar,
        );
        emit(state.copyWith(
          chats: chats,
          updating: false,
        ));
      } catch (err) {
        emit(state.copyWith(
          updating: false,
          error: err.toString(),
          changeError: true,
        ));
      }
    });
  }
}
