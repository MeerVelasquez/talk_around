import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/domain/models/message.dart';
import 'package:talk_around/domain/models/user.dart';
import 'package:talk_around/ui/controllers/app_controller.dart';
import 'package:talk_around/ui/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:talk_around/ui/widgets/app_bar_channel_widget.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({Key? key}) : super(key: key);

  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> with WidgetsBindingObserver {
  final AppController _appController = Get.find<AppController>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkMessages().catchError(logError);
    fetchUsersFromChannel().catchError(logError);
  }

  Future<void> checkMessages() async {
    try {
      await _appController.checkMessages();
    } catch (err) {
      logError(err);
    }
  }

  Future<void> fetchUsersFromChannel() async {
    try {
      await _appController.fetchUsersFromChannel();
    } catch (err) {
      logError(err);
    }
  }

  Future<void> onSendMessage() async {
    try {
      String text = _textEditingController.text;
      _textEditingController.clear();
      await _appController.sendMessage(text);
    } catch (err) {
      logError(err);
    }
  }

  Widget getMessages() {
    return Obx(() {
      if (_appController.messages == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      print(9);
      if (_appController.messages == null || _appController.messages!.isEmpty) {
        return const Center(
          child: Text("No messages"),
        );
      }
      return ListView.builder(
          itemCount: _appController.messages!.length,
          reverse: true,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            // return Text('asdasd');
            print(10);
            final Message message = _appController.messages![i];
            print(11);

            bool byCurrentUser = _appController.currentUser != null &&
                _appController.currentUser!.id! != message.senderId;
            print(12);

            final List<User> users = _appController.getUsersFromChannel();
            final int indexSender =
                users!.indexWhere((user) => user.id == message.senderId);
            final User? sender = indexSender != -1 ? users[indexSender] : null;
            print(13);

            print(sender != null ? sender.username : message.senderId);

            return Column(
              mainAxisAlignment: _appController.messages!.length > 1
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: byCurrentUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sender != null ? sender.username! : message.senderId,
                          style: const TextStyle(
                              color: Color(0xff013E6A),
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                            width: 200,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: byCurrentUser
                                    ? Color(0x013E6A).withOpacity(1)
                                    : Color(0x53F2D0).withOpacity(1)),
                            child: Text(
                              message.text,
                              style: TextStyle(
                                  color: byCurrentUser
                                      ? Colors.white
                                      : Color(0xff013E6A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarChannelWidget(),
      body: SafeArea(
          child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/img/fondo.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                // child: Container(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        child: getMessages(),
                        constraints: BoxConstraints(maxHeight: 600),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        height: 60,
                        width: double.infinity,
                        color: Color(0xffE7FCFD).withOpacity(0.7),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffC2DDE5),
                                    borderRadius: BorderRadius.circular(8)),
                                child: TextField(
                                  controller: _textEditingController,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      hintText: "Write message...",
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            FloatingActionButton(
                              onPressed: onSendMessage,
                              child: Icon(
                                Icons.send,
                                color: Color(0xff013E6A),
                                size: 18,
                              ),
                              backgroundColor: Colors.white,
                              elevation: 0,
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
