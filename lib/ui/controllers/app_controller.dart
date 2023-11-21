import 'package:get/get.dart';

import 'package:talk_around/domain/use_cases/auth_use_case.dart';
import 'package:talk_around/domain/use_cases/channel_use_case.dart';
import 'package:talk_around/domain/use_cases/message_use_case.dart';
import 'package:talk_around/domain/use_cases/topic_use_case.dart';
import 'package:talk_around/domain/use_cases/user_use_case.dart';

class AppController extends GetxController {
  AuthUseCase _authUseCase = Get.find<AuthUseCase>();
  ChannelUseCase _channelUseCase = Get.find<ChannelUseCase>();
  MessageUseCase _messageUseCase = Get.find<MessageUseCase>();
  TopicUseCase _topicUseCase = Get.find<TopicUseCase>();
  UserUseCase _userUseCase = Get.find<UserUseCase>();

  final Rx<bool> _isLoggedIn = Rx<bool>(false);
  final Rx<bool> _isAnonymous = Rx<bool>(false);

  bool get isLoggedIn => _isLoggedIn.value;
  bool get isAnonymous => _isAnonymous.value;

  @override
  void onInit() async {
    super.onInit();
    _isLoggedIn.value = await _authUseCase.isLoggedIn();
  }
}
