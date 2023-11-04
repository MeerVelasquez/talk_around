import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration(seconds: 3), () {
  //     Get.off(() => const LoginPage());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: Text('TalkAround'),
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
