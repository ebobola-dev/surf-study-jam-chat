import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/features/widgets/animated_dialog.dart';
import 'package:surf_practice_chat_flutter/features/widgets/my_text_field.dart';

class PasteImageUrlDialog extends StatefulWidget {
  const PasteImageUrlDialog({Key? key}) : super(key: key);

  @override
  State<PasteImageUrlDialog> createState() => _PasteImageUrlDialogState();
}

class _PasteImageUrlDialogState extends State<PasteImageUrlDialog> {
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width - ThemeConfig.defaultPadding * 2;
    final dialogWidth = screenWidth * .75;
    return AnimatedDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, _urlController.text),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
          ),
          child: Text('Прикрепить'.toUpperCase()),
        ),
      ],
      content: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Вставьте ссылку на изображение:',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 12),
            MyTextField(
              controller: _urlController,
              labelText: 'Вставьте ссылку',
            ),
          ],
        ),
      ),
    );
  }
}
