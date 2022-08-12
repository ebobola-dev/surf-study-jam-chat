import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/features/models/snack_type.dart';

void showGetSnackBar(
  BuildContext context,
  String message, {
  SnackPosition from = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
  SnackType type = SnackType.simple,
  Color? textColor,
  double? fontSize,
  String? buttonText,
  VoidCallback? onButtonTap,
  Color? buttonColor,
}) {
  assert(
    buttonText != null && onButtonTap != null ||
        buttonText == null && onButtonTap == null,
  );
  Get.snackbar(
    '',
    '',
    snackPosition: from,
    snackStyle: SnackStyle.FLOATING,
    duration: duration,
    borderRadius: 7.0,
    padding: EdgeInsets.zero,
    messageText: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if ([SnackType.error, SnackType.warning].contains(type)) ...[
                SvgPicture.asset(
                  type == SnackType.error
                      ? 'assets/icons/error.svg'
                      : 'assets/icons/warning.svg',
                  height: 32,
                  width: 32,
                  color: ThemeConfig.snackColors[type],
                ),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor ??
                        Theme.of(context).snackBarTheme.contentTextStyle!.color,
                    fontSize: fontSize ??
                        Theme.of(context)
                            .snackBarTheme
                            .contentTextStyle!
                            .fontSize,
                  ),
                  textAlign:
                      onButtonTap != null ? TextAlign.left : TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: ThemeConfig.snackColors[type],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(7.0),
              bottomRight: Radius.circular(7.0),
            ),
          ),
        ),
      ],
    ),
    titleText: Container(),
    margin: EdgeInsets.only(
      top: from == SnackPosition.TOP ? kBottomNavigationBarHeight : 0.0,
      bottom: from == SnackPosition.BOTTOM ? kBottomNavigationBarHeight : 0.0,
      left: 8,
      right: 8,
    ),
    mainButton: onButtonTap != null
        ? TextButton(
            onPressed: () {
              onButtonTap();
              Get.closeCurrentSnackbar();
            },
            child: Text(
              buttonText!,
              style: TextStyle(
                color: buttonColor ?? Theme.of(context).primaryColor,
                fontSize: 17.0,
              ),
            ),
          )
        : null,
  );
}
