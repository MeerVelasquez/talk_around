import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/domain/models/message.dart';
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
  }

  Future<void> checkMessages() async {
    try {
      await _appController.checkMessages();
    } catch (err) {
      logError(err);
    }
  }

  Future<void> onSendMessage() async {
    try {
      await _appController.sendMessage(_textEditingController.text);
      _textEditingController.clear();
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
      return ListView.builder(
          itemCount: _appController.messages!.length,
          reverse: true,
          itemBuilder: (context, i) {
            final Message message = _appController.messages![i];
            bool byCurrentUser = _appController.currentUser != null &&
                _appController.currentUser!.id! != message.senderId;

            return Column(
              mainAxisAlignment: _appController.messages!.length > 1
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.senderId,
                      style: const TextStyle(
                          color: Color(0xff013E6A),
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
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
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getMessages(),
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
                                  hintStyle: TextStyle(color: Colors.black54),
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
      )),
    );
  }
}
