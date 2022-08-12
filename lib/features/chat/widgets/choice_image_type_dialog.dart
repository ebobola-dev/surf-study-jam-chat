import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/features/widgets/animated_dialog.dart';

class ChoiceImageTypeDialog extends StatelessWidget {
  const ChoiceImageTypeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width - ThemeConfig.defaultPadding * 2;
    final dialogWidth = screenWidth * .75;
    return AnimatedDialog(
      content: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: null,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text(
                'С устройства',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text(
                'С интернета',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
