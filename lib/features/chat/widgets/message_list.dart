import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_state.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/message_card.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/scroll_down_button.dart';
import 'package:surf_practice_chat_flutter/utils/smallest_width.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final _scrollController = ScrollController();
  bool _showScrollButton = false;
  bool _weAreDown = false;
  Timer? _scrollTimer;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        //* isTop is True => we are at the top
        //* isTop is False => we are down
        setState(() {
          _weAreDown = !isTop;
        });
        if (!isTop && _showScrollButton) {
          setState(() {
            _showScrollButton = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          previous.messagesCount != current.messagesCount,
      buildWhen: (previous, current) =>
          previous.messages != current.messages ||
          previous.updating != current.updating,
      listener: (context, state) => _scrollToEnd(),
      builder: (context, chatState) {
        if (chatState.messagesCount == 0 && !chatState.updating) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/empty.png',
                width: getSmallestWidth(context) * .3,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                "Тут пока пусто...(",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 12),
              Text(
                "Отправьте первое сообщение!",
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          );
        }
        return Stack(
          children: [
            NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                final direction = notification.direction;
                setState(() {
                  if (direction == ScrollDirection.reverse && !_weAreDown) {
                    _showScrollButton = true;
                  } else if (direction == ScrollDirection.forward) {
                    setState(() {
                      _weAreDown = false;
                    });
                    _showScrollButton = false;
                  }
                });
                return true;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: chatState.messagesCount,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return MessageCard(
                    message: chatState.messages.elementAt(index),
                  );
                },
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              bottom: 5,
              right: _showScrollButton ? 5 : -70,
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 400),
                turns: _showScrollButton ? 0 : 1,
                child: ScrollDownButton(onTap: _scrollToEnd),
              ),
            ),
          ],
        );
      },
    );
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollTimer = Timer(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      });
    } else {
      log('not attached, there will be no scrolling');
    }
  }
}
