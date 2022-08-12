import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/features/models/snack_type.dart';

ThemeData getThemeData(BuildContext context) => ThemeData.light().copyWith(
      primaryColor: ThemeConfig.primaryColor,
      secondaryHeaderColor: ThemeConfig.secondaryColor,
      backgroundColor: ThemeConfig.backgroundColor,
      scaffoldBackgroundColor: ThemeConfig.backgroundColor,
      dividerColor: ThemeConfig.dividerColor,
      iconTheme: const IconThemeData(color: ThemeConfig.iconColor),
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w600,
        ), //* Auth screen titles
        headline2: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ), //* Big titles
        headline3: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
        headline4: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ), //* Header titles
        headline5: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ), //* Messages text
        headline6: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: Color(0xFFB4B4B4),
        ),
      ).apply(
        fontFamily: ThemeConfig.font,
        bodyColor: ThemeConfig.textColor1,
        displayColor: ThemeConfig.textColor1,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        color: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: ThemeConfig.iconColor),
        titleTextStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: ThemeConfig.textColor1,
          fontFamily: ThemeConfig.font,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: ThemeConfig.primaryColor,
          padding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 16.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          shadowColor: ThemeConfig.primaryColor,
          onSurface: Colors.grey,
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: ThemeConfig.font,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(
            color: ThemeConfig.primaryColor,
            fontFamily: ThemeConfig.font,
          ),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: ThemeConfig.primaryColor,
        secondary: ThemeConfig.secondaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(
          color: Color(0xFFB4B4B4),
          fontSize: 17.0,
          fontFamily: ThemeConfig.font,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.fromLTRB(16.0, 18.0, 10.0, 18.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ThemeConfig.snackColors[SnackType.simple]!,
        contentTextStyle: const TextStyle(
          fontSize: 18.0,
          fontFamily: ThemeConfig.font,
          color: ThemeConfig.textColor1,
        ),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFFF8F8F8),
        elevation: 0,
      ),
      dialogBackgroundColor: ThemeConfig.backgroundColor,
      dialogTheme: const DialogTheme(
        alignment: Alignment.center,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
      // bottomSheetTheme: BottomSheetThemeData(
      //   backgroundColor: Colors.transparent,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0),
      //   ),
      // ),
      // popupMenuTheme: const PopupMenuThemeData(
      //   color: ThemeConfig.backgroundColor,
      //   elevation: 7.0,
      //   textStyle: TextStyle(
      //     fontSize: 15.0,
      //     fontFamily: ThemeConfig.font,
      //   ),
      // ),
    );
