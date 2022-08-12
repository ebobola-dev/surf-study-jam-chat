import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';

class AnimatedDialog extends StatefulWidget {
  final Widget content;
  final List<Widget> actions;
  final Duration duration;

  const AnimatedDialog({
    Key? key,
    required this.content,
    this.actions = const [],
    this.duration = const Duration(milliseconds: 450),
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .75,
            child: AlertDialog(
              content: widget.content,
              actionsAlignment: MainAxisAlignment.center,
              contentPadding: const EdgeInsets.all(ThemeConfig.defaultPadding),
              actionsPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.zero,
              actions: [
                ...widget.actions,
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Закрыть".toUpperCase()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
