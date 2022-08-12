import 'package:equatable/equatable.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

class Chat extends Equatable {
  final String? name;
  final String? description;
  final String? avatar;

  const Chat({
    this.name,
    this.description,
    this.avatar,
  });

  Chat.fromSJChat({
    required SjChatDto sjChatDto,
  })  : name = sjChatDto.name,
        description = sjChatDto.description,
        avatar = sjChatDto.avatar;

  @override
  List<Object?> get props => [name, description, avatar];
}
