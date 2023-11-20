import 'package:flutter/material.dart';
import 'package:talk_around/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (err) {
    print(err);
  }
  runApp(const MyApp());
}
