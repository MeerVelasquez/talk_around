import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:talk_around/ui/controllers/app_controller.dart';

class AppBarHomeWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarHomeWidget({Key? key, required this.onPressedNotification})
      : super(key: key);

  final AppController _appController = Get.find<AppController>();
  final VoidCallback? onPressedNotification;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBar(
          backgroundColor: Colors.white,
          // backgroundColor: const Color(0xFFE7FCFD),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: _appController.isDrawerOpen
                ? Brightness.light
                : Brightness.dark,
            statusBarColor: _appController.isDrawerOpen
                ? const Color(0x013E6A).withOpacity(1)
                : Colors.white,
          ),
          shadowColor: Colors.black.withOpacity(0.3),
          title: Image.asset(
            'assets/img/logo_only.png',
            height: 50,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: onPressedNotification,
              icon: const Icon(
                Icons.person_rounded,
                // Icons.notifications,
                color: Color(0xFF013E6A),
              ),
            ),
          ],
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
