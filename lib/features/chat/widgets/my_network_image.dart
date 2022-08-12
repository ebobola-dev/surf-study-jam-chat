import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surf_practice_chat_flutter/features/widgets/rotation_loading_icon.dart';

class MyNetworkImage extends StatelessWidget {
  final String url;
  final double placeholderSize;
  final Radius placeholderRadius;
  const MyNetworkImage({
    Key? key,
    required this.url,
    this.placeholderSize = 120.0,
    this.placeholderRadius = const Radius.circular(12.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: placeholderSize,
          height: placeholderSize,
          child: const Center(
            child: RotationLoadingIcon(
              iconColor: Colors.grey,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        width: placeholderSize,
        height: placeholderSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(placeholderRadius),
          color: Colors.grey.withOpacity(.32),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/error.svg',
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              'Ошибка загрузки фото',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
