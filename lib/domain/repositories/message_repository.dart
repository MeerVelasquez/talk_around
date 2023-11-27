import 'package:talk_around/domain/models/message.dart';

abstract class MessageRepository {
  Stream<List<Message>?> getMessageChanges(String channelId, String userId);

  Future<List<Message>> getMessagesFromChannel(String channelId);

  Future<Message> createMessage(Message message);

  Future<void> deleteMessage(String id);
}
