import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'package:talk_around/config_app.dart';
import 'package:talk_around/my_app.dart';

Future<void> main() async {
  await configApp();
  runApp(const MyApp());
}
