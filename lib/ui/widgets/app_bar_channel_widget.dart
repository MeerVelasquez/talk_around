import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:talk_around/ui/controllers/app_controller.dart';

class AppBarChannelWidget extends StatelessWidget
    implements PreferredSizeWidget {
  AppBarChannelWidget({Key? key}) : super(key: key);

  final AppController _appController = Get.find<AppController>();

  void onGoBack() {
    try {
      _appController.getOutChannel();
    } catch (err) {
      logError('AppBarChannelWidget.onGoBack: $err');
    }
  }

  Widget getImage() {
    final Image imageWidget = _appController.currentChannel != null &&
            _appController.currentChannel!.imageUrl != null
        ? Image.network(_appController.currentChannel!.imageUrl!,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder:
                (BuildContext context, Object object, StackTrace? stacktrace) =>
                    Image.asset("assets/img/default_channel_1.jpg",
                        height: 40, fit: BoxFit.cover))
        : Image.asset("assets/img/default_channel_1.jpg",
            height: 40, fit: BoxFit.cover);
    return CircleAvatar(
      backgroundImage: imageWidget.image,
      maxRadius: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBar(
          // title: Text(_appController.currentChannel != null
          //     ? _appController.currentChannel!.name
          //     : 'Channel'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff013E6A).withOpacity(1),
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onGoBack,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color(0xffE7FCFD),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  getImage(),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _appController.currentChannel != null
                              ? _appController.currentChannel!.name
                              : 'Channel',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffE7FCFD)),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
