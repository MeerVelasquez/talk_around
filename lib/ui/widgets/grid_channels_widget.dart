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
    print('xd');
    // return GridView.builder(
    //   itemCount: channels.length,
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     childAspectRatio: 1.5,
    //   ),
    //   itemBuilder: (context, index) {
    //     final channel = channels[index];
    //     return GestureDetector(
    //       onTap: () => onTap(channel),
    //       child: Container(
    //         margin: const EdgeInsets.all(8),
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(8),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.grey.withOpacity(0.2),
    //               blurRadius: 4,
    //               offset: Offset(0, 2),
    //             ),
    //           ],
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(
    //               channel.name,
    //               style: TextStyle(
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             SizedBox(height: 8),
    //             Text(
    //               channel.description,
    //               style: TextStyle(
    //                 fontSize: 14,
    //                 color: Colors.grey,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 12,
      children: channels
          .map((channel) => ChannelItemWidget(channel: channel, onTap: onTap))
          .toList(),
    );
  }
}
