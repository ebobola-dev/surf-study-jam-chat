import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_state.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_event.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/features/chats/models/chat.dart';
import 'package:surf_practice_chat_flutter/utils/animated_swtich_page.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;
  const ChatCard({Key? key, required this.chat}) : super(key: key);

  static const cardRadius = Radius.circular(12.0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthorizedState) {
          animatedSwitchPage(
            context,
            BlocProvider(
              create: (context) => ChatBloc(
                chatRepository: ChatRepository(authState.authorizedClient),
                chat: chat,
              )..add(UpdateMessagesEvent()),
              child: const ChatScreen(),
            ),
            routeAnimation: RouteAnimation.slideLeft,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConfig.defaultPadding,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                chat.hasAvatar
                    ? chat.avatar!
                    : 'https://via.placeholder.com/600',
              ),
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.hasName ? chat.name! : 'Без названия',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: chat.hasName ? null : Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    chat.hasDescription ? chat.description! : '',
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
