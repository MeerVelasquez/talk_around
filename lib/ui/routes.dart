import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:talk_around/ui/middlewares/auth_middleware.dart';

import 'package:talk_around/ui/pages/chat_page.dart';
import 'package:talk_around/ui/pages/create_channel_page.dart';
import 'package:talk_around/ui/pages/first_page.dart';
import 'package:talk_around/ui/pages/home_page.dart';
import 'package:talk_around/ui/pages/interests_page.dart';
import 'package:talk_around/ui/pages/sign_in_page.dart';
import 'package:talk_around/ui/pages/profile_page.dart';
import 'package:talk_around/ui/pages/sign_up_page.dart';

// import 'package:talk_around/ui/middlewares/auth_middleware.dart';

abstract class AppRoutes {
  static const String chat = '/chat';
  static const String first = '/first';
  static const String home = '/';
  static const String interests = '/interests';
  static const String signIn = '/sign-in';
  static const String profile = '/profile';
  static const String signUp = '/sign-up';
  static const String createChannel = '/create-channel';
}

List<GetPage<dynamic>> appRoutes() => [
      GetPage(
        name: AppRoutes.chat,
        page: () => const ChatPage(
          key: Key('ChatPage'),
        ),
        // transition: Transition.leftToRightWithFade,
        // transitionDuration: Duration(milliseconds: 500),
        // middlewares: []
      ),
      GetPage(
          name: AppRoutes.first,
          page: () => const FirstPage(
                key: Key('FirstPage'),
              )
          // transition: Transition.leftToRightWithFade,
          // transitionDuration: Duration(milliseconds: 500),
          // middlewares: []
          ),
      GetPage(
          name: AppRoutes.home,
          page: () => const HomePage(
                key: Key('HomePage'),
              ),
          // transition: Transition.leftToRightWithFade,
          // transitionDuration: Duration(milliseconds: 500),
          middlewares: [AuthMiddleware()]),
      GetPage(
          name: AppRoutes.interests,
          page: () => const InterestsPage(
                key: Key('InterestsPage'),
              ),
          // transition: Transition.leftToRightWithFade,
          // transitionDuration: Duration(milliseconds: 500),
          middlewares: [AuthMiddleware()]),
      GetPage(
        name: AppRoutes.signIn,
        page: () => const SignInPage(
          key: Key('SignInPage'),
        ),
        // transition: Transition.leftToRightWithFade,
        // transitionDuration: Duration(milliseconds: 500),
        // middlewares: []
      ),
      GetPage(
          name: AppRoutes.profile,
          page: () => const ProfilePage(
                key: Key('ProfilePage'),
              ),
          // transition: Transition.leftToRightWithFade,
          // transitionDuration: Duration(milliseconds: 500),
          middlewares: [AuthMiddleware()]),
      GetPage(
        name: AppRoutes.signUp,
        page: () => const SignUpPage(
          key: Key('SignUpPage'),
        ),
        // transition: Transition.leftToRightWithFade,
        // transitionDuration: Duration(milliseconds: 500),
        // middlewares: [AuthMiddleware()]
      ),
      GetPage(
        name: AppRoutes.createChannel,
        page: () => const CreateChannelPage(
          key: Key('CreateChannelPage'),
        ),
        // transition: Transition.leftToRightWithFade,
        // transitionDuration: Duration(milliseconds: 500),
        // middlewares: [AuthMiddleware()]
      ),
    ];
