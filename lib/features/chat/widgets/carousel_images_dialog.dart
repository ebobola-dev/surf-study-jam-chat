import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/my_network_image.dart';
import 'package:surf_practice_chat_flutter/features/widgets/animated_dialog.dart';
import 'package:surf_practice_chat_flutter/utils/smallest_width.dart';

class CarouselImagesDialog extends StatefulWidget {
  final List<String> imageUrls;
  const CarouselImagesDialog({Key? key, required this.imageUrls})
      : super(key: key);

  @override
  State<CarouselImagesDialog> createState() => _CarouselImagesDialogState();
}

class _CarouselImagesDialogState extends State<CarouselImagesDialog> {
  double _markPosition = 0;

  @override
  Widget build(BuildContext context) {
    final scmallestWidth =
        getSmallestWidth(context) - ThemeConfig.defaultPadding * 2;
    final dialogWidth = scmallestWidth * .75;
    final markWidth = dialogWidth / widget.imageUrls.length - 2;
    return AnimatedDialog(
      content: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${widget.imageUrls.length} изображений(я)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 12),
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _markPosition = markWidth * index;
                  });
                },
              ),
              items: widget.imageUrls.map(
                (imageUrl) {
                  return MyNetworkImage(
                    url: imageUrl,
                    placeholderSize: scmallestWidth * .5,
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 3,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    left: _markPosition,
                    height: 3,
                    width: markWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
