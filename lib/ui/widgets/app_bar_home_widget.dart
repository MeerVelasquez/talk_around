import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarHomeWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHomeWidget({Key? key, required this.onPressedNotification})
      : super(key: key);

  final VoidCallback? onPressedNotification;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // backgroundColor: const Color(0xFFE7FCFD),
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.white,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
