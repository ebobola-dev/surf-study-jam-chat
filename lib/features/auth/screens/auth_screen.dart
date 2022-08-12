import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_event.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_state.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/chats/chats_event.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/widgets/loading_banner.dart';
import 'package:surf_practice_chat_flutter/features/auth/widgets/show_password_button.dart';
import 'package:surf_practice_chat_flutter/features/chats/repository/chats_repositoty.dart';
import 'package:surf_practice_chat_flutter/features/chats/screens/chats_screen.dart';
import 'package:surf_practice_chat_flutter/features/models/snack_type.dart';
import 'package:surf_practice_chat_flutter/features/widgets/my_text_field.dart';
import 'package:surf_practice_chat_flutter/utils/animated_swtich_page.dart';
import 'package:surf_practice_chat_flutter/utils/snack_bar.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

/// Screen for authorization process.
///
/// Contains [IAuthRepository] to do so.
class AuthScreen extends StatefulWidget {
  /// Constructor for [AuthScreen].
  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _scrollController = ScrollController();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    final authState = context.read<AuthBloc>().state;
    if (authState is NotAuthorizedState) {
      _loginController.text = authState.loginTextInput;
      _passwordController.text = authState.passwordTextInput;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final authBloc = context.read<AuthBloc>();
    return MultiBlocListener(
      listeners: [
        //* Listen authorization
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType,
          listener: (context, authState) {
            if (authState is AuthorizedState) {
              _pushToChat(context, authState.token);
            }
          },
        ),
        //* Listen authorization errors
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) {
            if (previous is NotAuthorizedState &&
                current is NotAuthorizedState) {
              return previous.authError == null && current.authError != null;
            }
            return previous.runtimeType != current.runtimeType;
          },
          listener: (context, authState) {
            if (authState is NotAuthorizedState) {
              showGetSnackBar(
                context,
                authState.authError!.message,
                from: SnackPosition.TOP,
                type: SnackType.error,
                textColor: Colors.red,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            //? For unfocus textfields on click outside
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(ThemeConfig.defaultPadding),
                    controller: _scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/chat.png',
                          width: 140.0,
                          height: 140.0,
                        ),
                        const SizedBox(height: 36.0),
                        Text(
                          'Chat App',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        const SizedBox(height: 36.0),
                        MyTextField(
                          controller: _loginController,
                          labelText: 'Введите логин',
                          onChanged: (newLoginText) =>
                              authBloc.add(ChangeLoginTextEvent(newLoginText)),
                          onClearTap: () => authBloc.add(ClearLoginTextEvent()),
                          onSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                        ),
                        const SizedBox(height: 23.0),
                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (previous, current) {
                            if (previous is NotAuthorizedState &&
                                current is NotAuthorizedState) {
                              return previous.showPassword !=
                                  current.showPassword;
                            }
                            return previous.runtimeType != current.runtimeType;
                          },
                          builder: (context, authState) {
                            if (authState.runtimeType != NotAuthorizedState) {
                              return Container();
                            }
                            authState as NotAuthorizedState;
                            return MyTextField(
                              controller: _passwordController,
                              labelText: 'Введите пароль',
                              onChanged: (newPasswordText) => authBloc.add(
                                  ChangePasswordTextEvent(newPasswordText)),
                              onClearTap: () =>
                                  authBloc.add(ClearPasswordTextEvent()),
                              focusNode: _passwordFocusNode,
                              obscureText: !authState.showPassword,
                              enableSuggestions: false,
                              autocorrect: false,
                              suffixWidgets: const [
                                ShowPasswordButton(),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 30.0),
                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (previous, current) {
                            if (previous is NotAuthorizedState &&
                                current is NotAuthorizedState) {
                              return previous.canLogin != current.canLogin;
                            }
                            return previous.runtimeType != current.runtimeType;
                          },
                          builder: (context, authState) {
                            if (authState.runtimeType != NotAuthorizedState) {
                              return Container();
                            }
                            authState as NotAuthorizedState;
                            return ElevatedButton(
                              onPressed: authState.canLogin
                                  ? () => authBloc.add(LoginEvent())
                                  : null,
                              child: const Text('Войти'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) {
                    if (previous is NotAuthorizedState &&
                        current is NotAuthorizedState) {
                      return previous.authorizationInProgress !=
                          current.authorizationInProgress;
                    }
                    return previous.runtimeType != current.runtimeType;
                  },
                  builder: (context, authState) {
                    if (authState.runtimeType != NotAuthorizedState) {
                      return Container();
                    }
                    authState as NotAuthorizedState;
                    return AnimatedPositioned(
                      left: authState.authorizationInProgress
                          ? ThemeConfig.defaultPadding
                          : -screenSize.width,
                      duration: const Duration(milliseconds: 500),
                      child: const LoadingBanner(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pushToChat(BuildContext context, TokenDto token) {
    animatedSwitchPage(
      context,
      BlocProvider(
        create: (context) => ChatsBloc(
          chatsRepository: ChatsRepository(
            StudyJamClient().getAuthorizedClient(token.token),
          ),
        )..add(UpdateChatsEvent()),
        child: const ChatsScreen(),
      ),
      routeAnimation: RouteAnimation.slideLeft,
      clearNavigator: true,
    );
  }
}
