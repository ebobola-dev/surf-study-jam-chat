import 'package:equatable/equatable.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

class Chat extends Equatable {
  final int id;
  final String? name;
  final String? description;
  final String? avatar;

  const Chat({
    required this.id,
    this.name,
    this.description,
    this.avatar,
  });

  bool get hasName => name != null && name!.isNotEmpty;
  bool get hasDescription => description != null && description!.isNotEmpty;
  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;

  Chat.fromSJChat({
    required SjChatDto sjChatDto,
  })  : id = sjChatDto.id,
        name = sjChatDto.name,
        description = sjChatDto.description,
        avatar = sjChatDto.avatar;

  @override
  List<Object?> get props => [name, description, avatar];
}
