import 'package:talk_around/data/datasources/local/topic_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/topic_datasource.dart';

import 'package:talk_around/domain/models/topic.dart';
import 'package:talk_around/domain/repositories/topic_repository.dart';

class TopicFirebaseRepository implements TopicRepository {
  final TopicLocalDatasource _topicLocalDatasource = TopicLocalDatasource();
  final TopicDatasource _topicDatasource = TopicDatasource();

  Future<Topic> getTopic(String id) async {}

  Future<List<Topic>> getTopics() async {}

  Future<Topic> createTopic(Topic topic) async {}

  Future<void> deleteTopic() async {}
}
