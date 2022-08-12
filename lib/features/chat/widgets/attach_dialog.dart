import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surf_practice_chat_flutter/assets/themes/theme_config.dart';
import 'package:surf_practice_chat_flutter/bloc/chat/chat_state.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/agree_location_dialog.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/carousel_images_dialog.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/choice_image_type_dialog.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/paste_image_url_dialog.dart';
import 'package:surf_practice_chat_flutter/features/widgets/animated_dialog.dart';

class AttachDialog extends StatefulWidget {
  final ChatState chatState;
  final void Function(ChatGeolocationDto) onAttachGeo;
  final void Function(String) onAttachImage;
  final void Function(String) onDetachImage;
  final VoidCallback onDetachGeo;
  final VoidCallback onDetachAllImages;
  final VoidCallback onDetachAll;
  const AttachDialog({
    Key? key,
    required this.chatState,
    required this.onAttachGeo,
    required this.onAttachImage,
    required this.onDetachImage,
    required this.onDetachGeo,
    required this.onDetachAllImages,
    required this.onDetachAll,
  }) : super(key: key);

  @override
  State<AttachDialog> createState() => _AttachDialogState();
}

class _AttachDialogState extends State<AttachDialog> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width - ThemeConfig.defaultPadding * 2;
    final imagesCount = widget.chatState.attachedImagesCount;
    final dialogWidth = screenWidth * .75;
    return AnimatedDialog(
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Button(
                onTap: _attachPhotos,
                text: 'Прикрепить фото',
                svgPath: 'assets/icons/attach-file.svg',
                disable: !widget.chatState.canAttachImage,
              ),
              const SizedBox(height: 12),
              _Button(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CarouselImagesDialog(
                      imageUrls: widget.chatState.attachedImages,
                    ),
                  );
                },
                text: 'Посмотреть все фото($imagesCount)',
                svgPath: 'assets/icons/list.svg',
                disable: !widget.chatState.imagesAttached,
              ),
              const SizedBox(height: 12),
              _Button(
                onTap: () {
                  widget.onDetachAllImages();
                  Navigator.pop(context);
                },
                text: 'Удалить всё фото($imagesCount)',
                svgPath: 'assets/icons/detach-file.svg',
                disable: !widget.chatState.imagesAttached,
              ),
              const SizedBox(height: 12),
              _Button(
                onTap: _attachGeo,
                text: 'Прикрепить геолокацию',
                svgPath: 'assets/icons/attach-location.svg',
              ),
              const SizedBox(height: 12),
              _Button(
                onTap: () {
                  widget.onDetachGeo();
                  Navigator.pop(context);
                },
                text: 'Удалить геолокацию',
                svgPath: 'assets/icons/detach-location.svg',
                disable: !widget.chatState.geoAttached,
              ),
              const SizedBox(height: 12),
              _Button(
                onTap: () {
                  widget.onDetachAll();
                  Navigator.pop(context);
                },
                text: 'Удалить всё',
                svgPath: 'assets/icons/disable.svg',
                disable: widget.chatState.attachedCount == 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _attachPhotos() async {
    final isLocal = await showDialog<bool>(
      context: context,
      builder: (context) => const ChoiceImageTypeDialog(),
    );
    if (isLocal == null) return;
    if (isLocal) {
      final images = await _pickImages();
      //TODO upload images to host and attach urls
    } else {
      final imageUrl = await showDialog<String>(
        context: context,
        builder: (context) => const PasteImageUrlDialog(),
      );
      if (imageUrl != null && imageUrl.isNotEmpty) {
        widget.onAttachImage(imageUrl);
        Navigator.pop(context);
      }
    }
  }

  Future<List<XFile>?> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    return images;
  }

  Future<void> _attachGeo() async {
    final attachResult = await showDialog<bool>(
      context: context,
      builder: (context) => const AgreeLocationDialog(),
    );
    //? Пишу так потому что attachResult может быть null
    if (attachResult == true) {
      final location = await _getCurrentPosition();
      if (location != null) {
        widget.onAttachGeo(location);
        Navigator.pop(context);
      }
    }
  }

  Future<ChatGeolocationDto?> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return null;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    return ChatGeolocationDto(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
}

class _Button extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String svgPath;
  final bool disable;
  const _Button({
    Key? key,
    required this.onTap,
    required this.text,
    required this.svgPath,
    this.disable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disable ? null : onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            svgPath,
            height: 24,
            color: disable ? Colors.grey : Theme.of(context).iconTheme.color,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: disable ? Colors.grey : null),
          ),
        ],
      ),
    );
  }
}
