import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_state.dart';
import 'package:surf_practice_chat_flutter/features/chats/widgets/chat_card.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsBloc, ChatsState>(
      buildWhen: (previous, current) => previous.chats != current.chats,
      builder: (context, chatState) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: chatState.chatsCount,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ChatCard(chat: chatState.chats.elementAt(index));
          },
        );
      },
    );
  }
}
