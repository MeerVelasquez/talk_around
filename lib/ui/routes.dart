import 'package:get/get.dart';
import 'package:talk_around/ui/middlewares/auth_middleware.dart';

import 'package:talk_around/ui/pages/chat_page.dart';
import 'package:talk_around/ui/pages/first_page.dart';
import 'package:talk_around/ui/pages/home_page.dart';
import 'package:talk_around/ui/pages/interests_page.dart';
import 'package:talk_around/ui/pages/sign_in_page.dart';
import 'package:talk_around/ui/pages/profile_page.dart';
import 'package:talk_around/ui/pages/sign_up_page.dart';

// import 'package:talk_around/ui/middlewares/auth_middleware.dart';

abstract class AppRoutes {
  static const chat = '/chat';
  static const first = '/first';
  static const home = '/';
  static const interests = '/interests';
  static const signIn = '/sign-in';
  static const profile = '/profile';
  static const signUp = '/sign-up';
}

List<GetPage<dynamic>> appRoutes() => [
      GetPage(
        name: AppRoutes.chat,
        page: () => const ChatPage(),

        // transition: Transition.leftToRightWithFade,
        // transitionDuration: Duration(milliseconds: 500),
        // middlewares: []
      ),
      GetPage(
        name: AppRoutes.first,
        page: () => const FirstPage(),
        // transition: Transition.leftToRightWithFade,
        // transitionDuration: Duration(milliseconds: 500),
        // middlewares: []
      ),
      GetPage(
          name: AppRoutes.home,
          page: () => const HomePage(),
          // transition: Transition.leftToRightWithFade,
          // transitionDuration: Duration(milliseconds: 500),
          middlewares: [AuthMiddleware()]),
      GetPage(
          name: AppRoutes.interests,
          page: () => const InterestsPage(),
          // transition: Transition.leftToRightWithFade,
          // transitionDuration: Duration(milliseconds: 500),
          middlewares: [AuthMiddleware()]),
      GetPage(
        name: AppRoutes.signIn,
        page: () => const SignInPage(),
        // transition: Transition.leftToRightWithFade,
        // transitionDuration: Duration(milliseconds: 500),
        // middlewares: []
      ),
      GetPage(
          name: AppRoutes.profile,
          page: () => const ProfilePage(),
          // transition: Transition.leftToRightWithFade,
          // transitionDuration: Duration(milliseconds: 500),
          middlewares: [AuthMiddleware()]),
      GetPage(
        name: AppRoutes.signUp,
        page: () => const SignUpPage(),
        // transition: Transition.leftToRightWithFade,
        // transitionDuration: Duration(milliseconds: 500),
        // middlewares: [AuthMiddleware()]
      ),
    ];
