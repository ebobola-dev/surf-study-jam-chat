import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_event.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_state.dart';
import 'package:surf_practice_chat_flutter/features/widgets/my_text_field.dart';

class InputMessage extends StatefulWidget {
  const InputMessage({Key? key}) : super(key: key);

  @override
  State<InputMessage> createState() => _InputMessageState();
}

class _InputMessageState extends State<InputMessage> {
  final messageFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final chatBloc = context.read<ChatBloc>();
    messageFieldController.text = chatBloc.state.messageField;
    messageFieldController.addListener(() {
      chatBloc.add(
        ChangeMessageFieldEvent(messageFieldController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ThemeConfig.defaultPadding / 2,
        ThemeConfig.defaultPadding / 4,
        ThemeConfig.defaultPadding / 2,
        ThemeConfig.defaultPadding,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            splashRadius: 24,
            icon: SvgPicture.asset(
              'assets/icons/attach-file.svg',
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: ThemeConfig.defaultPadding / 2),
          Flexible(
            child: MyTextField(
              maxLines: 5,
              controller: messageFieldController,
              labelText: "Введите сообщение...",
              onClearTap: () => chatBloc.add(
                ClearMessageFieldEvent(),
              ),
            ),
          ),
          const SizedBox(width: ThemeConfig.defaultPadding / 2),
          BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (previous, current) =>
                previous.canSend != current.canSend,
            builder: (context, chatState) {
              return IconButton(
                onPressed: chatState.canSend
                    ? () {
                        chatBloc.add(SendMessageEvent());
                        messageFieldController.clear();
                      }
                    : null,
                splashRadius: 24,
                icon: SvgPicture.asset(
                  'assets/icons/send.svg',
                  color: chatState.canSend ? null : Colors.grey,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
