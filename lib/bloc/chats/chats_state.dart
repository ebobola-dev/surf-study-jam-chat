import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/features/chats/models/chat.dart';

class ChatsState extends Equatable {
  final Iterable<Chat> chats;
  final bool updating;
  final String? error;

  const ChatsState({
    this.chats = const [],
    this.updating = false,
    this.error,
  });

  bool get isError => error != null;
  int get chatsCount => chats.length;

  @override
  List<Object?> get props => [
        chats,
        updating,
        error,
      ];

  ChatsState copyWith({
    Iterable<Chat>? chats,
    bool? updating,
    String? error,
    bool changeError = false,
  }) =>
      ChatsState(
        chats: chats ?? this.chats,
        updating: updating ?? this.updating,
        error: changeError ? error : this.error,
      );
}
