import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_event.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_state.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/widgets/loading_banner.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/widgets/show_password_button.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/features/models/snack_type.dart';
import 'package:surf_practice_chat_flutter/features/widgets/my_text_field.dart';
import 'package:surf_practice_chat_flutter/utils/get_nav_bar.dart';
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
              return previous.authErrors != current.authErrors;
            }
            return previous.runtimeType != current.runtimeType;
          },
          listener: (context, authState) {
            if (authState is NotAuthorizedState) {
              showGetSnackBar(
                context,
                authState.authErrors.last.message,
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
                          'Wellcome Back!',
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
                      top: authState.authorizationInProgress
                          ? 0.0
                          : -screenSize.height,
                      duration: const Duration(milliseconds: 800),
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChatScreen(
            chatRepository: ChatRepository(
              StudyJamClient().getAuthorizedClient(token.token),
            ),
          );
        },
      ),
    );
  }
}
