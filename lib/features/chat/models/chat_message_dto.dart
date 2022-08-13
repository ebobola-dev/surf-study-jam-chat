import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_local_dto.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

class ChatMessageDto extends Equatable {
  final ChatUserDto chatUserDto;
  final String? message;
  final DateTime createdDateTime;

  //* Added by me
  final ChatGeolocationDto? location;
  final List<String>? imageUrls;

  bool get hasUserName => chatUserDto.name != null;
  bool get hasAvatar => chatUserDto.avatar != null;
  bool get hasMessage => message != null && message!.isNotEmpty;
  bool get hasLocation => location != null;
  bool get hasImages => imageUrls != null && imageUrls!.isNotEmpty;
  //*

  const ChatMessageDto({
    required this.chatUserDto,
    required this.message,
    required this.createdDateTime,
    this.location,
    this.imageUrls,
  });

  ChatMessageDto.fromSJClient({
    required SjMessageDto sjMessageDto,
    required SjUserDto sjUserDto,
    required bool isUserLocal,
  })  : location = sjMessageDto.geopoint == null
            ? null
            : ChatGeolocationDto.fromGeoPoint(sjMessageDto.geopoint!),
        imageUrls = sjMessageDto.images,
        chatUserDto = isUserLocal
            ? ChatUserLocalDto.fromSJClient(sjUserDto)
            : ChatUserDto.fromSJClient(sjUserDto),
        message = sjMessageDto.text,
        createdDateTime = sjMessageDto.created;

  @override
  String toString() =>
      'ChatMessageDto(chatUserDto: $chatUserDto, message: $message, createdDate: $createdDateTime)';

  //* Added by me
  @override
  List<Object?> get props => [
        chatUserDto,
        message,
        createdDateTime,
        location,
        imageUrls,
      ];

  String getStringTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDay = DateTime(
        createdDateTime.year, createdDateTime.month, createdDateTime.day);
    if (messageDay == yesterday) {
      //? Yesterday
      return 'Вчера, ${DateFormat.Hm().format(createdDateTime)}';
    }
    if (messageDay == today) {
      //? today
      return DateFormat.Hm().format(createdDateTime);
    }
    if (createdDateTime.year != now.year) {
      return DateFormat('dd.MM.yyyy, HH:mm').format(createdDateTime);
    }
    return DateFormat('dd.MM, HH:mm').format(createdDateTime);
  }
}
