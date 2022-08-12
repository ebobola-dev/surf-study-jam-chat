import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/features/widgets/rotation_loading_icon.dart';

class LoadingBanner extends StatelessWidget {
  const LoadingBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final borderRadius = BorderRadius.circular(15.0);

    return SizedBox(
      width: screenSize.width - ThemeConfig.defaultPadding * 2,
      height: screenSize.height - ThemeConfig.defaultPadding * 4,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.5,
            sigmaY: 2.5,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.25),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationLoadingIcon(
                  iconColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Авторизация...',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
