import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'package:talk_around/ui/controllers/app_controller.dart';

import 'package:talk_around/domain/use_cases/auth_use_case.dart';
import 'package:talk_around/domain/use_cases/channel_use_case.dart';
import 'package:talk_around/domain/use_cases/message_use_case.dart';
import 'package:talk_around/domain/use_cases/topic_use_case.dart';
import 'package:talk_around/domain/use_cases/user_use_case.dart';

import 'package:talk_around/domain/repositories/auth_repository.dart';
import 'package:talk_around/domain/repositories/channel_repository.dart';
import 'package:talk_around/domain/repositories/message_repository.dart';
import 'package:talk_around/domain/repositories/topic_repository.dart';
import 'package:talk_around/domain/repositories/user_repository.dart';

import 'package:talk_around/data/repositories/auth_firebase_repository.dart';
import 'package:talk_around/data/repositories/channel_firebase_repository.dart';
import 'package:talk_around/data/repositories/message_firebase_repository.dart';
import 'package:talk_around/data/repositories/topic_firebase_repository.dart';
import 'package:talk_around/data/repositories/user_firebase_repository.dart';

Future<void> configApp() async {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (err) {
    logError(err);
  }

  Get.put<AppController>(AppController());

  Get.put<AuthUseCase>(AuthUseCase());
  Get.put<ChannelUseCase>(ChannelUseCase());
  Get.put<MessageUseCase>(MessageUseCase());
  Get.put<TopicUseCase>(TopicUseCase());
  Get.put<UserUseCase>(UserUseCase());

  Get.put<AuthRepository>(AuthFirebaseRepository());
  Get.put<ChannelRepository>(ChannelFirebaseRepository());
  Get.put<MessageRepository>(MessageFirebaseRepository());
  Get.put<TopicRepository>(TopicFirebaseRepository());
  Get.put<UserRepository>(UserFirebaseRepository());
}
