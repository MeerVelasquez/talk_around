import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_around/ui/controllers/app_controller.dart';
import 'package:talk_around/ui/pages/sign_in_page.dart';
import 'package:talk_around/ui/widgets/button_primary_widget.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final AppController _appController = Get.find<AppController>();

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration(seconds: 3), () {
  //     Get.off(() => const LoginPage());
  //   });
  // }

  void onGetStarted() {
    _appController.getStarted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF2F2F2).withOpacity(1),
      body: Stack(
        children: [
          Image.asset(
            'assets/img/fondo.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/logo.png',
                  width: 360,
                  height: 365,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 25),
                Text(
                  'Chat with Locals',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Anywhere, anytime',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 25),
                ButtonPrimaryWidget(
                  key: const Key('getStartedButton'),
                  onPressed: onGetStarted,
                  text: 'Get Started',
                  fontSize: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
