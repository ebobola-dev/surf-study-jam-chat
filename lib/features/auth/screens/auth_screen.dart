import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

/// Screen for authorization process.
///
/// Contains [IAuthRepository] to do so.
class AuthScreen extends StatefulWidget {
  /// Repository for auth implementation.
  final IAuthRepository authRepository;

  /// Constructor for [AuthScreen].
  const AuthScreen({
    required this.authRepository,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _scrollController = ScrollController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          //* For unfocus textfields on click outside
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeConfig.defaultPadding),
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/chat.png',
                    width: 140.0,
                    height: 140.0,
                  ),
                  const SizedBox(height: 36.0),
                  Text(
                    'Wellcome Back!',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(height: 36.0),
                  TextField(
                    controller: _loginController,
                    style: const TextStyle(
                      color: ThemeConfig.inputTextColor,
                      fontSize: 16.0,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Введите логин',
                    ),
                  ),
                  const SizedBox(height: 23.0),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(
                      color: ThemeConfig.inputTextColor,
                      fontSize: 16.0,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Введите пароль',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pushToChat(BuildContext context, TokenDto token) {
    Navigator.push<ChatScreen>(
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
