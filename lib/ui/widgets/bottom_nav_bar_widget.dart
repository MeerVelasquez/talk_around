import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:loggy/loggy.dart';

import 'package:talk_around/ui/controllers/app_controller.dart';
import 'package:talk_around/ui/routes.dart';

class BottomNavBarWidget extends StatelessWidget {
  BottomNavBarWidget({Key? key}) : super(key: key);

  final AppController _appController = Get.find<AppController>();
  static final List<BottomNavBarSection> sections = [
    BottomNavBarSection(
      // index: 0,
      route: AppRoutes.profile,
      icon: Icons.people,
      title: 'Profile',
    ),
    BottomNavBarSection(
      // index: 1,
      route: AppRoutes.home,
      icon: Icons.home,
      title: 'Home',
    ),
    BottomNavBarSection(
      // index: 2,
      route: AppRoutes.createChannel,
      icon: Icons.add,
      title: 'New channel',
    ),
  ];

  void onTap(int index) {
    try {
      _appController.selectBottomNavBarItem(index);
    } catch (err) {
      logError('BottomNavBarWidget.onTap: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ConvexAppBar(
          items: sections
              .map((section) => TabItem(
                    icon: Icon(section.icon,
                        color: section.route ==
                                sections[_appController.currentSection ?? 0]
                                    .route
                            ? Colors.black
                            : Colors.white),
                    title: section.title,
                  ))
              .toList(),
          activeColor: Colors.white,
          color: Colors.white,
          initialActiveIndex: _appController.currentSection,
          backgroundColor: Color(0xFF013E6A),
          onTap: onTap,
        ));
  }
}

class BottomNavBarSection {
  BottomNavBarSection({
    // required this.index,
    required this.route,
    required this.icon,
    required this.title,
  });

  // final int index;
  final String route;
  final IconData icon;
  final String title;
}
