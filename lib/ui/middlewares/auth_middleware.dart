import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:talk_around/ui/controllers/app_controller.dart';
import 'package:talk_around/ui/routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (Get.find<AppController>().isLoggedIn) {
      return null;
    } else {
      return const RouteSettings(name: AppRoutes.signIn);
    }
  }
}
