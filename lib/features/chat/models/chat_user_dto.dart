import 'package:equatable/equatable.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

/// Basic model, representing chat user.
class ChatUserDto extends Equatable {
  /// User's name.
  ///
  /// May be `null`.
  final String? name;
  //* Added by me
  final int id;
  final String? avatar;

  /// Constructor for [ChatUserDto].
  const ChatUserDto({
    required this.name,
    required this.id,
    required this.avatar,
  });

  /// Factory-like constructor for converting DTO from [StudyJamClient].
  ChatUserDto.fromSJClient(SjUserDto sjUserDto)
      : name = sjUserDto.username,
        id = sjUserDto.id,
        avatar = sjUserDto.avatar;

  @override
  String toString() => 'ChatUserDto(name: $name, id: $id)';

  @override
  List<Object?> get props => [id, name, avatar];
}
