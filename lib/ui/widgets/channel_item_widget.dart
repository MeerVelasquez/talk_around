import 'package:flutter/material.dart';
import 'package:talk_around/domain/models/channel.dart';

class ChannelItemWidget extends StatelessWidget {
  final Channel channel;
  final Function onTap;

  const ChannelItemWidget({
    Key? key,
    required this.channel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   onTap: () => onTap(channel),
    //   leading: CircleAvatar(
    //     backgroundImage: NetworkImage(channel.imageUrl),
    //   ),
    //   title: Text(channel.name),
    //   subtitle: Text(channel.description),
    // );
    return GestureDetector(
      onTap: () => onTap(channel),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              channel.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              channel.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
