import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/domain/models/message.dart';
import 'package:talk_around/domain/models/user.dart';
import 'package:talk_around/ui/controllers/app_controller.dart';
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
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<List<Message>?>? _messageSubscription;

  final Rx<List<Message>?> _messages = Rx<List<Message>?>(null);

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   _scrollToBottom();
    // });

    checkMessages();
    fetchUsersFromChannel();

    _messageSubscription =
        _appController.messagesPublic.listen((List<Message>? messages) {
      print('scrolling');
      _messages.value = messages;
      _messages.refresh();
      print(_messages.value?.map((e) => e.text).toList());
      if (messages != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _scrollToBottom();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageSubscription?.cancel();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
      String text = _textEditingController.text.trim();
      if (text != '') {
        if (_scaffoldKey.currentContext != null) {
          FocusScope.of(_scaffoldKey.currentContext!).unfocus();
        }

        _textEditingController.clear();
        await _appController.sendMessage(text);
      }
    } catch (err) {
      logError(err);
    }
  }

  Widget getMessages() {
    return Obx(() {
      print('NEW OBX UPDATE HAHAHHA');
      if (_messages.value == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (_messages.value == null || _messages.value!.isEmpty) {
        return const Center(
          child: Text("No messages"),
        );
      }
      return ListView.builder(
          controller: _scrollController,
          itemCount: _messages.value!.length,
          reverse: false,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            // return Text('asdasd');
            final Message message = _messages.value![i];

            bool byCurrentUser = _appController.currentUser != null &&
                _appController.currentUser!.id! == message.senderId;

            final List<User> users = _appController.getUsersFromChannel();
            final int indexSender =
                users!.indexWhere((user) => user.id == message.senderId);
            final User? sender = indexSender != -1 ? users[indexSender] : null;
            // if (sender != null) {
            //   print('sender ${sender!.username}');
            // }

            return Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Column(
                mainAxisAlignment: _messages.value!.length > 1
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
                            byCurrentUser
                                ? 'You ${message.createdAt}'
                                : sender != null && sender.username != ''
                                    ? sender.username
                                    : message.senderId,
                            style: const TextStyle(
                                color: Color(0xff013E6A),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                      // bottomLeft
                                      offset: Offset(-1.5, -1.5),
                                      color: Colors.white),
                                  Shadow(
                                      // bottomRight
                                      offset: Offset(1.5, -1.5),
                                      color: Colors.white),
                                  Shadow(
                                      // topRight
                                      offset: Offset(1.5, 1.5),
                                      color: Colors.white),
                                  Shadow(
                                      // topLeft
                                      offset: Offset(-1.5, 1.5),
                                      color: Colors.white),
                                ]),
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
              ),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        // resizeToAvoidBottomInset: false,
        appBar: AppBarChannelWidget(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
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
                        child: getMessages(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}
