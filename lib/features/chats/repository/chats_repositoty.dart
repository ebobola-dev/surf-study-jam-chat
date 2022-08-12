import 'package:surf_practice_chat_flutter/features/chats/models/chat.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

abstract class IChatsRepository {
  static const int maxMessageLength = 300;

  Future<Iterable<Chat>> createChat(Chat chat);

  Future<Iterable<Chat>> getChats();
}

class ChatsRepository implements IChatsRepository {
  final StudyJamClient _studyJamClient;

  ChatsRepository(this._studyJamClient);

  @override
  Future<Iterable<Chat>> createChat(Chat chat) async {
    try {
      await _studyJamClient.createChat(SjChatSendsDto(
        name: chat.name,
        description: chat.description,
        avatar: chat.avatar,
      ));
      final chats = await _fetchAllChats();
      return chats;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  @override
  Future<Iterable<Chat>> getChats() async {
    try {
      final chats = await _fetchAllChats();
      return chats;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<Iterable<Chat>> _fetchAllChats() async {
    final ids = await _studyJamClient.getUpdates(chats: DateTime(2022));
    if (ids.chats == null) {
      return [];
    }
    final chatsData =
        await _studyJamClient.getChatsByIds(ids.chats!.take(1000).toList());
    return chatsData.map((sjChat) => Chat.fromSJChat(sjChatDto: sjChat));
  }
}
