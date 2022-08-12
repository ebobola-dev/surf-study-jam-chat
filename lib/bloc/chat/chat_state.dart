import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';

class ChatState extends Equatable {
  static const maxImagesCount = 10;

  final bool updating;
  final String? error;
  final String messageField;
  final Iterable<ChatMessageDto> messages;
  final List<String> attachedImages;
  final ChatGeolocationDto? attachedGeolocation;

  const ChatState({
    this.error,
    this.updating = false,
    this.messageField = '',
    this.messages = const [],
    this.attachedImages = const [],
    this.attachedGeolocation,
  });

  bool get imagesAttached => attachedImages.isNotEmpty;

  int get attachedImagesCount => attachedImages.length;

  bool get geoAttached => attachedGeolocation != null;

  int get attachedCount => attachedImagesCount + (geoAttached ? 1 : 0);

  bool get canAttachImage => attachedImages.length < maxImagesCount;

  bool get canSend => messageField.isNotEmpty || imagesAttached || geoAttached;

  int get messagesCount => messages.length;

  bool get isError => error != null;

  @override
  List<Object?> get props => [
        error,
        messages,
        updating,
        messageField,
        attachedImages,
        attachedGeolocation,
      ];

  ChatState copyWith({
    String? messageField,
    Iterable<ChatMessageDto>? messages,
    bool? updating,
    String? error,
    bool changeError = false,
    List<String>? attachedImages,
    ChatGeolocationDto? attachedGeolocation,
    bool changeAttachedGeolocation = false,
  }) =>
      ChatState(
        messageField: messageField ?? this.messageField,
        messages: messages ?? this.messages,
        updating: updating ?? this.updating,
        error: changeError ? error : this.error,
        attachedImages: attachedImages ?? this.attachedImages,
        attachedGeolocation: changeAttachedGeolocation
            ? attachedGeolocation
            : this.attachedGeolocation,
      );
}
