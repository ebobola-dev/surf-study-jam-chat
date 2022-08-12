import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/features/widgets/animated_dialog.dart';

class AgreeLocationDialog extends StatelessWidget {
  const AgreeLocationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width - ThemeConfig.defaultPadding * 2;
    final dialogWidth = screenWidth * .75;
    return AnimatedDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text('Прикрепить'.toUpperCase()),
        ),
      ],
      content: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Вы уверены что хотите прикрепить ',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  TextSpan(
                    text: 'свою',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                  TextSpan(
                    text: ' геолокацию?',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
