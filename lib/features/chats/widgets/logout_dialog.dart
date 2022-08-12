import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/widgets/animated_dialog.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;
  const LogoutDialog({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedDialog(
      actions: [
        TextButton(
          onPressed: () {
            onLogout();
            Navigator.pop(context);
          },
          child: Text('Выйти'.toUpperCase()),
        ),
      ],
      content: SizedBox(
        width: screenWidth * .75,
        child: Text(
          'Вы уверены что хотите выйти?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
