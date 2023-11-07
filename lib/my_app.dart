//create the structure for my app and call the first page

import 'package:flutter/material.dart';
import 'package:talk_around/ui/pages/first_page.dart';
import 'package:talk_around/ui/pages/login_page.dart';
import 'package:talk_around/ui/pages/signup_page.dart';

MaterialColor myPrimarySwatch = MaterialColor(0xFF997AC1, {
  50: Color(0xFFF5EEF7),
  100: Color(0xFFE4D6E5),
  200: Color(0xFFD3BED4),
  300: Color(0xFFC2A6C4),
  400: Color(0xFFB18EB3),
  500: Color(0xFF997AC1), // Este es el tono principal
  600: Color(0xFF8A6CB0),
  700: Color(0xFF7C5FA0),
  800: Color(0xFF6D5190),
  900: Color(0xFF5F4480),
});

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  // The first page is called here
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talk Around',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: myPrimarySwatch,
        primaryColor: Color(0x013E6A),
      ),
      home: const SignUpPage(),
    );
  }
}
