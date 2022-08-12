import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/widgets/animated_dialog.dart';
import 'package:surf_practice_chat_flutter/features/widgets/my_text_field.dart';

class CreateChatDialog extends StatefulWidget {
  final void Function(String, String, String) onCreate;
  const CreateChatDialog({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  @override
  State<CreateChatDialog> createState() => _CreateChatDialogState();
}

class _CreateChatDialogState extends State<CreateChatDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _avatarController = TextEditingController();
  final _descriptionFocusNode = FocusNode();
  final _avatarFocusNode = FocusNode();

  bool _showWarning = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedDialog(
      actions: [
        TextButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onCreate(
                _nameController.text,
                _descriptionController.text,
                _avatarController.text,
              );
              Navigator.pop(context);
            } else {
              setState(() {
                _showWarning = true;
              });
            }
          },
          child: Text('Создать'.toUpperCase()),
        ),
      ],
      content: SizedBox(
        width: screenWidth * .75,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Создайте чат!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 12),
              MyTextField(
                controller: _nameController,
                labelText: 'Придумайте название',
                errorText: _showWarning ? 'Название чата обязательно' : null,
                maxLines: 1,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onChanged: (newText) {
                  if (newText.isNotEmpty && _showWarning) {
                    setState(() {
                      _showWarning = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              MyTextField(
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                labelText: 'Придумайте описание',
                maxLines: 5,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_avatarFocusNode);
                },
              ),
              const SizedBox(height: 12),
              MyTextField(
                controller: _avatarController,
                focusNode: _avatarFocusNode,
                labelText: 'Ссылка на фото для аватара чата',
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
