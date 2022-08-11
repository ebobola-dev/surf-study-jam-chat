import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

/// Data transfer object representing geolocation chat message.
class ChatMessageGeolocationDto extends ChatMessageDto {
  /// Location point.
  final ChatGeolocationDto location;

  /// Constructor for [ChatMessageGeolocationDto].
  ChatMessageGeolocationDto({
    required ChatUserDto chatUserDto,
    required this.location,
    required String message,
    required DateTime createdDate,
  }) : super(
          chatUserDto: chatUserDto,
          message: message,
          createdDateTime: createdDate,
        );

  /// Named constructor for converting DTO from [StudyJamClient].
  ChatMessageGeolocationDto.fromSJClient({
    required SjMessageDto sjMessageDto,
    required SjUserDto sjUserDto,
  })  : location = ChatGeolocationDto.fromGeoPoint(sjMessageDto.geopoint!),
        super(
          createdDateTime: sjMessageDto.created,
          message: sjMessageDto.text,
          chatUserDto: ChatUserDto.fromSJClient(sjUserDto),
        );

  @override
  String toString() => 'ChatMessageGeolocationDto(location: $location) extends ${super.toString()}';
}
