import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_event.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_state.dart';
import 'package:surf_practice_chat_flutter/features/chats/widgets/create_chat_dialog.dart';
import 'package:surf_practice_chat_flutter/features/widgets/rotation_loading_icon.dart';

class ChatsHeader extends StatelessWidget {
  const ChatsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatsBloc = context.read<ChatsBloc>();
    return AppBar(
      leadingWidth: 24 * 2 + ThemeConfig.defaultPadding,
      leading: IconButton(
        key: const ValueKey(1),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CreateChatDialog(
              onCreate: (name, description, avatarUrl) =>
                  chatsBloc.add(CreateChatEvent(
                name: name,
                description: description,
                avatar: avatarUrl,
              )),
            ),
          );
        },
        splashRadius: 24.0,
        icon: SvgPicture.asset(
          'assets/icons/plus.svg',
          color: Theme.of(context).appBarTheme.iconTheme!.color,
        ),
      ),
      title: const Text('Чаты'),
      actions: [
        BlocBuilder<ChatsBloc, ChatsState>(
          buildWhen: (previous, current) =>
              previous.updating != current.updating,
          builder: (context, chatsState) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: chatsState.updating
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
                      onPressed: () => chatsBloc.add(UpdateChatsEvent()),
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
