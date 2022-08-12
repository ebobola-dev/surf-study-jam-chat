import 'package:flutter/material.dart';

@immutable
abstract class ChatsEvent {}

class UpdateChatsEvent extends ChatsEvent {}

class CreateChatEvent extends ChatsEvent {
  final String? name;
  final String? description;
  final String? avatar;
  CreateChatEvent({
    this.name,
    this.description,
    this.avatar,
  });
}
