import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScrollDownButton extends StatelessWidget {
  final VoidCallback onTap;
  const ScrollDownButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.0,
      height: 42.0,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.32),
              offset: const Offset(2, 2),
              spreadRadius: 1,
              blurRadius: 7,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 13, 10, 10),
            child: SvgPicture.asset(
              'assets/icons/bottom-arrow.svg',
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
