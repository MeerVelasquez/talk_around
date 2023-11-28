// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:talk_around/domain/models/message.dart';

class MessageDatasource {
  // final firebase_auth.FirebaseAuth _inst = firebase_auth.FirebaseAuth.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'message';

  final Rx<List<Message>?> messageChanges = Rx<List<Message>?>(null);

  void getMessageChanges(String channelId, String userId) {
    _db
        .collection(_collection)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> event) {
      print('Event received ${event.docs.length}}');
      // List<Message> messages = event.docs.map((doc) {
      //   Map<String, dynamic> messageMap = doc.data() as Map<String, dynamic>;
      //   messageMap['id'] = doc.id;
      //   return Message.fromJson(messageMap);
      // }).where((element) {
      //   return element.channelId == channelId;
      // }).where((element) {
      //   return element.deleted == false;
      //   // }).where((element) {
      //   //   return element.senderId != userId;
      // }).toList();
      // print(messages.map((e) => e.text).toList());
      // messages.sort((a, b) {
      //   if (a.createdAt != null && b.createdAt != null) {
      //     return a.createdAt!.compareTo(b.createdAt!);
      //   } else if (a.createdAt != null) {
      //     return 1;
      //   } else if (b.createdAt != null) {
      //     return -1;
      //   } else {
      //     return 0;
      //   }
      // });
      // print(messages.map((e) => e.text).toList());
      List<Message> messages = _parseMessages(event.docs, channelId);
      messageChanges.value = messages;
    });
  }

  Future<List<Message>> getMessagesFromChannel(String channelId) async {
    QuerySnapshot query = await _db
        .collection(_collection)
        .where('channelId', isEqualTo: channelId)
        .get();
    // return query.docs.map((doc) {
    //   Map<String, dynamic> messageMap = doc.data() as Map<String, dynamic>;
    //   messageMap['id'] = doc.id;
    //   return Message.fromJson(messageMap);
    // }).toList();
    return _parseMessages(query.docs, channelId);
  }

  Future<Message> createMessage(Message message) async {
    print(message);
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

  List<Message> _parseMessages(
      List<QueryDocumentSnapshot> docs, String channelId) {
    List<Message> messages = docs.map((doc) {
      Map<String, dynamic> messageMap = doc.data() as Map<String, dynamic>;
      messageMap['id'] = doc.id;
      return Message.fromJson(messageMap);
    }).where((element) {
      return element.channelId == channelId;
    }).where((element) {
      return element.deleted == false;
      // }).where((element) {
      //   return element.senderId != userId;
    }).toList();
    print(messages.map((e) => e.text).toList());
    messages.sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        return a.createdAt!.compareTo(b.createdAt!);
      } else if (a.createdAt != null) {
        return 1;
      } else if (b.createdAt != null) {
        return -1;
      } else {
        return 0;
      }
    });
    print(messages.map((e) => e.text).toList());
    return messages.reversed.take(100).toList().reversed.toList();
  }
}
