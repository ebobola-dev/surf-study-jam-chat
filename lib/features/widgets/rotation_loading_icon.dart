import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RotationLoadingIcon extends StatefulWidget {
  final Color? iconColor;
  final double iconSize;
  final Duration rotateDuration;
  const RotationLoadingIcon({
    Key? key,
    this.iconColor,
    this.iconSize = 24.0,
    this.rotateDuration = const Duration(milliseconds: 2000),
  }) : super(key: key);

  @override
  State<RotationLoadingIcon> createState() => _RotationLoadingIconState();
}

class _RotationLoadingIconState extends State<RotationLoadingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotateController = AnimationController(
    vsync: this,
    duration: widget.rotateDuration,
  )..repeat();

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(_rotateController),
      child: SvgPicture.asset(
        'assets/icons/loading.svg',
        color: widget.iconColor ?? Theme.of(context).iconTheme.color,
        width: widget.iconSize,
        height: widget.iconSize,
      ),
    );
  }
}
