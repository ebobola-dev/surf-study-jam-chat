import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextStyle textStyle;
  final String labelText;
  final VoidCallback? onClearTap;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final List<Widget> suffixWidgets;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  const MyTextField({
    Key? key,
    this.textStyle = const TextStyle(
      color: ThemeConfig.inputTextColor,
      fontSize: 16.0,
    ),
    required this.controller,
    this.focusNode,
    required this.labelText,
    this.onClearTap,
    this.onSubmitted,
    this.onChanged,
    this.suffixWidgets = const [],
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool showClearButton = false;

  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.text.isEmpty && showClearButton) {
        if (mounted) {
          setState(() {
            showClearButton = false;
          });
        }
      }
      if (widget.controller.text.isNotEmpty && !showClearButton) {
        if (mounted) {
          setState(() {
            showClearButton = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: widget.textStyle,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      enableSuggestions: widget.enableSuggestions,
      autocorrect: widget.autocorrect,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.suffixWidgets,
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: showClearButton ? 1.0 : 0.0,
              child: Material(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50.0),
                  onTap: () {
                    widget.controller.clear();
                    if (widget.onClearTap != null) {
                      widget.onClearTap!();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      'assets/icons/cross.svg',
                      color: Colors.grey,
                      height: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
