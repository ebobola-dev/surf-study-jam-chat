import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_state.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageCard extends StatelessWidget {
  final ChatMessageDto message;
  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final authState = context.read<AuthBloc>().state;
    final ourId = authState is AuthorizedState ? authState.me?.id : null;
    final bool isOurMessage = ourId == message.chatUserDto.id;
    final messageTextStyle = Theme.of(context).textTheme.headline5!.copyWith(
          color: isOurMessage ? Colors.white : null,
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isOurMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenSize.width * .6),
          child: Card(
            color: isOurMessage ? Theme.of(context).secondaryHeaderColor : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12.0),
                topRight: const Radius.circular(12.0),
                bottomRight:
                    isOurMessage ? Radius.zero : const Radius.circular(12.0),
                bottomLeft:
                    isOurMessage ? const Radius.circular(12.0) : Radius.zero,
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
                                  message.location!.longitude),
                              child: Text(
                                'локация',
                                textAlign: TextAlign.left,
                                style: messageTextStyle.copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                      Text(
                        message.getStringTime(),
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: isOurMessage
                                  ? Colors.white.withOpacity(.72)
                                  : Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> _openMap(double latitude, double longitude) async {
    final googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
