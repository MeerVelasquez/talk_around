import 'package:flutter/material.dart';
import 'package:talk_around/config_app.dart';
import 'package:talk_around/my_app.dart';

Future<void> main() async {
  await configApp();
  runApp(const MyApp());
}
