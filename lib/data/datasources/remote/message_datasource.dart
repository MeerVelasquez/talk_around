import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talk_around/domain/models/message.dart';

class MessageDatasource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'message';

  Future<List<Message>> getMessagesFromChannel(String channelId) async {
    QuerySnapshot query = await _db
        .collection(_collection)
        .where('channelId', isEqualTo: channelId)
        .get();
    return query.docs.map((doc) {
      Map<String, dynamic> messageMap = doc.data() as Map<String, dynamic>;
      messageMap['id'] = doc.id;
      return Message.fromJson(messageMap);
    }).toList();
  }

  Future<Message> createMessage(Message message) async {
    DocumentReference docRef =
        await _db.collection(_collection).add(message.toJson());
    message.id = docRef.id;
    return message;
  }

  Future<void> deleteMessage(String id) async {
    await _db.collection(_collection).doc(id).update({
      'deleted': true,
    });
  }
}
