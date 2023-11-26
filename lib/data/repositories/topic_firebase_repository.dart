import 'package:loggy/loggy.dart';
import 'package:talk_around/data/datasources/local/topic_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/topic_datasource.dart';
import 'package:talk_around/services/network_service.dart';

import 'package:talk_around/domain/models/topic.dart';
import 'package:talk_around/domain/repositories/topic_repository.dart';

class TopicFirebaseRepository implements TopicRepository {
  final TopicLocalDatasource _topicLocalDatasource = TopicLocalDatasource();
  final TopicDatasource _topicDatasource = TopicDatasource();

  @override
  Future<Topic> getTopic(String id) async {
    try {
      return await _topicDatasource.getTopic(id);
    } catch (err) {
      if (!(await NetworkService.hasNetwork())) {
        return await _topicLocalDatasource.getTopic(id);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<List<Topic>> getTopics() async {
    try {
      final List<Topic> topics = await _topicDatasource.getTopics();
      _topicLocalDatasource.setTopics(topics).catchError((err) {
        logError(err);
      });
      return topics;
    } catch (err) {
      if (!(await NetworkService.hasNetwork())) {
        return await _topicLocalDatasource.getTopics();
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<Topic> createTopic(Topic topic) async {
    final Topic newTopic = await _topicDatasource.createTopic(topic);
    _topicLocalDatasource.addTopic(newTopic);
    return newTopic;
  }

  @override
  Future<void> deleteTopic() async {
    return await _topicDatasource.deleteTopic();
  }
}
