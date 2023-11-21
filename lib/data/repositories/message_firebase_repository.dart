import 'package:talk_around/data/datasources/local/message_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/message_datasource.dart';

import 'package:talk_around/domain/models/message.dart';
import 'package:talk_around/domain/repositories/message_repository.dart';

class MessageFirebaseRepository implements MessageRepository {
  final MessageLocalDatasource _messageLocalDatasource =
      MessageLocalDatasource();
  final MessageDatasource _messageDatasource = MessageDatasource();

  Future<List<Message>> getMessagesFromChannel() async {}

  Future<Message> createMessage(Message message) async {}

  Future<void> deleteMessage(String id) async {}
}
