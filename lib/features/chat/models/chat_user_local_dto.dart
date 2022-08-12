import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

/// Model representing local user.
///
/// As rule as user with the same nickname was entered when sending a message
/// from this device.
class ChatUserLocalDto extends ChatUserDto with EquatableMixin {
  /// Constructor for [ChatUserLocalDto].
  ChatUserLocalDto({
    required int id,
    required String? name,
    required String? avatar,
  }) : super(id: id, name: name, avatar: avatar);

  /// Factory-like constructor for converting DTO from [StudyJamClient].
  ChatUserLocalDto.fromSJClient(SjUserDto sjUserDto)
      : super(
          id: sjUserDto.id,
          name: sjUserDto.username,
          avatar: sjUserDto.avatar,
        );

  @override
  String toString() => 'ChatUserLocalDto(name: $name, id: $id)';

  @override
  List<Object?> get props => [name, id, avatar];
}
