import 'package:flutter/material.dart';

@immutable
abstract class ChatEvent {}

class ChangeMessageFieldEvent extends ChatEvent {
  final String newMessageFieldText;
  ChangeMessageFieldEvent(this.newMessageFieldText);
}

class ClearMessageFieldEvent extends ChatEvent {}

class UpdateMessagesEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {}
