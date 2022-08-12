import 'package:flutter/material.dart';

@immutable
abstract class ChatsEvent {}

class UpdateChatsEvent extends ChatsEvent {}

class CreateChatEvent extends ChatsEvent {
  final String? name;
  final String? descriprion;
  final String? avatar;
  CreateChatEvent({
    this.name,
    this.descriprion,
    this.avatar,
  });
}
