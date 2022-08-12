import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_event.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_state.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_state.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/auth_screen.dart';
import 'package:surf_practice_chat_flutter/features/chats/widgets/chat_list.dart';
import 'package:surf_practice_chat_flutter/features/chats/widgets/header.dart';
import 'package:surf_practice_chat_flutter/features/chats/widgets/logout_dialog.dart';
import 'package:surf_practice_chat_flutter/features/models/snack_type.dart';
import 'package:surf_practice_chat_flutter/utils/animated_swtich_page.dart';
import 'package:surf_practice_chat_flutter/utils/snack_bar.dart';

/// Main screen of chat app, containing messages.
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        ///* Listen logout
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType,
          listener: (context, authState) {
            if (authState is NotAuthorizedState) {
              animatedSwitchPage(
                context,
                const AuthScreen(),
                routeAnimation: RouteAnimation.slideRight,
                clearNavigator: true,
              );
            }
          },
        ),

        ///* listen errors
        BlocListener<ChatsBloc, ChatsState>(
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
      ],
      child: GestureDetector(
        onTap: () {
          //? For unfocus textfields on click outside
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: ChatsHeader(),
          ),
          body: Column(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: ThemeConfig.defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Expanded(child: ChatList()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => LogoutDialog(
                  onLogout: () => context.read<AuthBloc>().add(
                        LogoutEvent(),
                      ),
                ),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/logout.svg',
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
