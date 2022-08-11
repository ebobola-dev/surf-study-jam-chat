import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

/// Model representing local user.
///
/// As rule as user with the same nickname was entered when sending a message
/// from this device.
class ChatUserLocalDto extends ChatUserDto {
  /// Constructor for [ChatUserLocalDto].
  ChatUserLocalDto({
    required String name,
  }) : super(name: name);

  /// Factory-like constructor for converting DTO from [StudyJamClient].
  ChatUserLocalDto.fromSJClient(SjUserDto sjUserDto) : super(name: sjUserDto.username);

  @override
  String toString() => 'ChatUserLocalDto(name: $name)';
}
