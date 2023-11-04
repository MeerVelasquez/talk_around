//create the structure for my app and call the first page

import 'package:flutter/material.dart';
import 'package:talk_around/ui/pages/first_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  // The first page is called here
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talk Around',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstPage(),
    );
  }
}
