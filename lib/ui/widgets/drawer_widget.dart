import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/ui/controllers/app_controller.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({
    Key? key,
  }) : super(key: key);

  final AppController _appController = Get.find<AppController>();
  final TextEditingController _geolocRadiusController = TextEditingController();

  void onLogout() async {
    try {
      await _appController.logOut();
    } catch (err) {
      logError(err);
    }
  }

  void onToggleGeoloc(bool value) {
    try {
      _appController.toggleGeoloc(value);
    } catch (err) {
      logError(err);
    }
  }

  void onGeolocRadiusChanged(String value) {
    try {
      _appController.geolocRadius = double.parse(value);
    } catch (err) {
      logError(err);
    }
  }

  Widget getToggleGeolocWidget() => Obx(
        () => Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Geolocation',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(
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
                )
              ],
            ),
          ],
        ),
      );

  Widget getGeolocPrefs() => Obx(() {
        if (!_appController.isGeolocEnabled) return Container();
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'People within',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 200,
                      child: TextField(
                        cursorColor: Colors.white,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          // labelText: 'Maximum distance',
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                          ),
                          // border: OutlineInputBorder(),
                          // border: InputBorder.none,
                          // fillColor: Colors.white,
                          filled: true,
                        ),
                        controller: _geolocRadiusController,
                        onChanged: onGeolocRadiusChanged,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      'km',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ],
        );
      });

  @override
  Widget build(BuildContext context) {
    if (_appController.geolocRadius != null) {
      _geolocRadiusController.text = _appController.geolocRadius.toString();
    }
    return Drawer(
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
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      Text(
                        // _appController.currentUser != null ? _appController.currentUser!.email : 'email@domain.com',
                        _appController.currentUser != null
                            ? '@${_appController.currentUser!.username}'
                            : '@username',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      getGeolocPrefs(),
                      const SizedBox(
                        height: 16,
                      ),
                      getToggleGeolocWidget(),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: onLogout,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 32,
                        color: Colors.white,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
