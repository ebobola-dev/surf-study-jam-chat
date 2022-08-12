import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';

@immutable
abstract class ChatEvent {}

class ChangeMessageFieldEvent extends ChatEvent {
  final String newMessageFieldText;
  ChangeMessageFieldEvent(this.newMessageFieldText);
}

class ClearMessageFieldEvent extends ChatEvent {}

class AttachImage extends ChatEvent {
  final String newImageUrl;
  AttachImage(this.newImageUrl);
}

class DetachImage extends ChatEvent {
  final String imagePath;
  DetachImage(this.imagePath);
}

class DetachAllImages extends ChatEvent {}

class AttachGeolocation extends ChatEvent {
  final ChatGeolocationDto geolocation;
  AttachGeolocation(this.geolocation);
}

class DetachGeolocation extends ChatEvent {}

class DetachAll extends ChatEvent {}

class UpdateMessagesEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {}
