import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_event.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_state.dart';
import 'package:surf_practice_chat_flutter/features/widgets/rotation_loading_icon.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();
    return AppBar(
      leadingWidth: 24 * 2 + ThemeConfig.defaultPadding,
      leading: IconButton(
        key: const ValueKey(1),
        onPressed: () {},
        splashRadius: 24.0,
        icon: SvgPicture.asset(
          'assets/icons/edit.svg',
          color: Theme.of(context).appBarTheme.iconTheme!.color,
        ),
      ),
      title: const Text('Сообщения'),
      actions: [
        BlocBuilder<ChatBloc, ChatState>(
          buildWhen: (previous, current) =>
              previous.updating != current.updating,
          builder: (context, chatState) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: chatState.updating
                  ? IconButton(
                      key: const ValueKey(0),
                      onPressed: null,
                      icon: RotationLoadingIcon(
                        iconColor:
                            Theme.of(context).appBarTheme.iconTheme!.color,
                      ),
                    )
                  : IconButton(
                      key: const ValueKey(1),
                      onPressed: () => chatBloc.add(UpdateMessagesEvent()),
                      splashRadius: 24.0,
                      icon: SvgPicture.asset(
                        'assets/icons/refresh.svg',
                        color: Theme.of(context).appBarTheme.iconTheme!.color,
                      ),
                    ),
            );
          },
        ),
        const SizedBox(width: ThemeConfig.defaultPadding - 6),
      ],
    );
  }
}
