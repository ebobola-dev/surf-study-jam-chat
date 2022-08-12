import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_state.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/carousel_images_dialog.dart';
import 'package:surf_practice_chat_flutter/features/chat/widgets/my_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageCard extends StatelessWidget {
  final ChatMessageDto message;
  const MessageCard({Key? key, required this.message}) : super(key: key);

  static const cardRadius = Radius.circular(12.0);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxCardWidth = screenSize.width * .6;
    final authState = context.read<AuthBloc>().state;
    final ourId = authState is AuthorizedState ? authState.me?.id : null;
    final bool isOurMessage = ourId == message.chatUserDto.id;
    final messageTextStyle = Theme.of(context).textTheme.headline5!.copyWith(
          color: isOurMessage ? Colors.white : null,
        );
    final smallTextColor =
        isOurMessage ? Colors.white.withOpacity(.72) : Colors.grey;
    final fewImages =
        message.imageUrls == null ? null : message.imageUrls!.length > 1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          isOurMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isOurMessage)
          MessageAvatar(
            sender: message.chatUserDto,
            isOurMessage: isOurMessage,
          ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxCardWidth),
          child: Card(
            color: isOurMessage ? Theme.of(context).secondaryHeaderColor : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: cardRadius,
                topRight: cardRadius,
                bottomRight: isOurMessage ? Radius.zero : cardRadius,
                bottomLeft: isOurMessage ? cardRadius : Radius.zero,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.hasLocation) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Прикреплена',
                              textAlign: TextAlign.left,
                              style: messageTextStyle,
                            ),
                            TextButton(
                              onPressed: () => _openMap(
                                message.location!.latitude,
                                message.location!.longitude,
                              ),
                              child: Text(
                                'локация',
                                textAlign: TextAlign.left,
                                style: messageTextStyle.copyWith(
                                  color: isOurMessage
                                      ? Colors.yellow
                                      : Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (message.hasImages || message.hasMessage) ...[
                          Text(
                            '- ' * 18,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: smallTextColor),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ],
                      if (message.hasImages) ...[
                        GestureDetector(
                          onTap: fewImages!
                              ? () => _openImagesDialog(context)
                              : null,
                          child: Badge(
                            showBadge: fewImages,
                            badgeColor: Theme.of(context).secondaryHeaderColor,
                            badgeContent: fewImages
                                ? Text(
                                    message.imageUrls!.length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(color: Colors.white),
                                  )
                                : null,
                            child: MyNetworkImage(
                              url: message.imageUrls!.first,
                              placeholderSize: maxCardWidth - 20 * 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (message.hasMessage) ...[
                          Text(
                            '- ' * 18,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: smallTextColor),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ],
                      if (message.hasMessage) ...[
                        Text(
                          message.message ?? '',
                          textAlign: TextAlign.left,
                          style: messageTextStyle,
                          softWrap: true,
                        ),
                        const SizedBox(height: 10),
                      ],
                      Wrap(
                        children: [
                          if (!isOurMessage)
                            Text(
                              message.hasUserName
                                  ? "${message.chatUserDto.name!}, "
                                  : "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    color: smallTextColor,
                                  ),
                            ),
                          Text(
                            message.getStringTime(),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: smallTextColor,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isOurMessage)
          MessageAvatar(
            sender: message.chatUserDto,
            isOurMessage: isOurMessage,
          ),
      ],
    );
  }

  Future<void> _openMap(double latitude, double longitude) async {
    final googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  void _openImagesDialog(BuildContext context) {
    if (message.imageUrls == null) return;
    if (message.imageUrls!.length < 2) return;
    showDialog(
      context: context,
      builder: (context) => CarouselImagesDialog(imageUrls: message.imageUrls!),
    );
  }
}

class MessageAvatar extends StatelessWidget {
  final ChatUserDto sender;
  final bool isOurMessage;
  const MessageAvatar({
    Key? key,
    required this.sender,
    this.isOurMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isOurMessage) const SizedBox(width: 12),
        if (sender.avatar != null)
          CircleAvatar(
            backgroundImage: NetworkImage(
              sender.avatar!,
            ),
          ),
        if (!isOurMessage) const SizedBox(width: 12),
      ],
    );
  }
}
