import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/models/snack_type.dart';

class ThemeConfig {
  static const primaryColor = Color(0xFF003049);
  static const secondaryColor = Color(0xFF04CA5F);
  static const backgroundColor = Color(0xFFFFFFFF);

  static const textColor1 = Color(0xFF191A23);
  static const textColor2 = Color(0xFF000000);
  static const inputTextColor = Color(0xFF404040);

  static const iconColor = Color(0xFF191A23); // = TextColor1
  static const buttonColor = Color(0xFF003049);
  static const dividerColor = Color(0xFFEDEDEE);

  static const snackColors = {
    SnackType.simple: Color(0xFF0064dd),
    SnackType.good: Color(0xFF438272),
    SnackType.warning: Color(0xFFed8327),
    SnackType.error: Color(0xFFC72C41),
  };

  static const font = 'Inter';
  static const defaultPadding = 12.0;
}
