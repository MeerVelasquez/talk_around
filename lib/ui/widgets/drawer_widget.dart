import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/ui/controllers/app_controller.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({
    Key? key,
  }) : super(key: key);

  final AppController _appController = Get.find<AppController>();

  void onLogout() async {
    try {
      await _appController.logOut();
    } catch (err) {
      logError(err);
    }
  }

  void onToggleGeoloc(bool value) {
    try {
      _appController.toggleGeolocLocal(value);
    } catch (err) {
      logError(err);
    }
  }

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: const Color(0x013E6A).withOpacity(1),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 16),
            child: Column(
              // padding: EdgeInsets.zero,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 96,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset("assets/img/perfil.jpeg"),
                            )),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          _appController.currentUser != null
                              ? _appController.currentUser!.name
                              : 'User',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                        Text(
                          // _appController.currentUser != null ? _appController.currentUser!.email : 'email@domain.com',
                          _appController.currentUser != null
                              ? '@${_appController.currentUser!.username}'
                              : '@username',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Geolocation',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            Obx(() => SizedBox(
                                  width: 96,
                                  height: 72,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Switch(
                                      // This bool value toggles the switch.
                                      value: _appController.isGeolocEnabled,
                                      activeColor: Colors.green,
                                      onChanged: onToggleGeoloc,
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                GestureDetector(
                  onTap: onLogout,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 36,
                        color: Colors.white,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
