import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talk_around/domain/models/topic.dart';

class TopicDatasource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'topic';

  Future<Topic> getTopic(String id) async {
    DocumentSnapshot doc = await _db.collection(_collection).doc(id).get();
    if (!doc.exists) {
      return Future.error('No topic with id $id');
    }
    Map<String, dynamic> topicMap = doc.data() as Map<String, dynamic>;
    topicMap['id'] = doc.id;
    return Topic.fromJson(topicMap);
  }

  Future<List<Topic>> getTopics() async {
    QuerySnapshot query = await _db.collection(_collection).get();
    return query.docs.map((doc) {
      Map<String, dynamic> topicMap = doc.data() as Map<String, dynamic>;
      topicMap['id'] = doc.id;
      return Topic.fromJson(topicMap);
    }).toList();
  }

  Future<Topic> createTopic(Topic topic) async {
    final Topic newTopic = Topic.from(topic);
    DocumentReference docRef =
        await _db.collection(_collection).add(topic.toJson());
    newTopic.id = docRef.id;
    return newTopic;
  }

  Future<void> deleteTopic() async {}
}
