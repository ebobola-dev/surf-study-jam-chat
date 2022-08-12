import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/header.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/input_message.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/message_list.dart';

/// Main screen of chat app, containing messages.
class ChatScreen extends StatelessWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
