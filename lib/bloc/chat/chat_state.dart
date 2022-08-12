import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';

class ChatState extends Equatable {
  final bool updating;
  final String? error;
  final String messageField;
  final Iterable<ChatMessageDto> messages;

  const ChatState({
    this.error,
    this.updating = false,
    this.messageField = '',
    this.messages = const [],
  });

  bool get canSend => messageField.isNotEmpty;

  int get messagesCount => messages.length;

  bool get isError => error != null;

  @override
  List<Object?> get props => [
        error,
        messages,
        updating,
        messageField,
      ];

  ChatState copyWith({
    String? messageField,
    Iterable<ChatMessageDto>? messages,
    bool? updating,
    String? error,
    bool changeError = false,
  }) =>
      ChatState(
        messageField: messageField ?? this.messageField,
        messages: messages ?? this.messages,
        updating: updating ?? this.updating,
        error: changeError ? error : this.error,
      );
}
