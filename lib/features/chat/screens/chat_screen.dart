import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_state.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/header.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/input_message.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/message_list.dart';
import 'package:surf_practice_chat_flutter/features/models/snack_type.dart';
import 'package:surf_practice_chat_flutter/utils/snack_bar.dart';

/// Main screen of chat app, containing messages.
class ChatScreen extends StatelessWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        ///* Error listener
        BlocListener<ChatBloc, ChatState>(
          listenWhen: (previous, current) {
            return !previous.isError && current.isError;
          },
          listener: (context, chatState) {
            showGetSnackBar(
              context,
              chatState.error!,
              from: SnackPosition.TOP,
              type: SnackType.error,
              textColor: Colors.red,
            );
          },
        ),

        ///* Attach geo listener
        BlocListener<ChatBloc, ChatState>(
          listenWhen: (previous, current) {
            return !previous.geoAttached && current.geoAttached;
          },
          listener: (context, chatState) {
            showGetSnackBar(
              context,
              'Вы прикрепили к сообщению своё местоположение',
              from: SnackPosition.TOP,
              type: SnackType.warning,
              duration: const Duration(seconds: 2),
            );
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          //? For unfocus textfields on click outside
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: ChatHeader(),
          ),
          body: Column(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    ThemeConfig.defaultPadding,
                    0,
                    ThemeConfig.defaultPadding,
                    ThemeConfig.defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Expanded(child: MessageList()),
                    ],
                  ),
                ),
              ),
              const InputMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
