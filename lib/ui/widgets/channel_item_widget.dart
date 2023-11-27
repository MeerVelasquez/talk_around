import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:talk_around/domain/models/channel.dart';
import 'package:talk_around/domain/models/topic.dart';
import 'package:talk_around/ui/controllers/app_controller.dart';

class ChannelItemWidget extends StatelessWidget {
  final AppController _appController = Get.find<AppController>();

  final Channel channel;
  final Function onTap;

  ChannelItemWidget({
    Key? key,
    required this.channel,
    required this.onTap,
  }) : super(key: key);

  Widget getContent() {
    if (_appController.topics == null) return getMainContent();

    final int topicIndex = _appController.topics!
        .indexWhere((topic) => topic.id == channel.topicId);
    if (topicIndex == -1) return getMainContent();

    final Topic topic = _appController.topics![topicIndex];
    return ClipRect(
      child: Banner(
          message: topic.title,
          child: getMainContent(),
          color: const Color(0x013E6A).withOpacity(1),
          location: BannerLocation.topStart,
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
    );
  }

  Widget getMainContent() {
    final Image imageWidget = channel.imageUrl != null
        ? Image.network(channel.imageUrl!,
            height: 96,
            fit: BoxFit.cover,
            errorBuilder:
                (BuildContext context, Object object, StackTrace? stacktrace) =>
                    Image.asset("assets/img/default_channel_1.jpg",
                        height: 96, fit: BoxFit.cover))
        : Image.asset("assets/img/default_channel_1.jpg",
            height: 96, fit: BoxFit.cover);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0x799AB1).withOpacity(1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: imageWidget,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  channel.name,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(channel.description,
                    style: const TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(channel),
      child: getContent(),
    );
  }
}
