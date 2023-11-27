import 'package:flutter/material.dart';
import 'package:talk_around/domain/models/channel.dart';
import 'package:talk_around/ui/widgets/channel_item_widget.dart';

class GridChannelsWidget extends StatelessWidget {
  final List<Channel> channels;
  final Function(Channel) onTap;

  const GridChannelsWidget({
    Key? key,
    required this.channels,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 12,
      children: channels
          .map((channel) => ChannelItemWidget(channel: channel, onTap: onTap))
          .toList(),
    );
  }
}
