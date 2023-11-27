//create the structure for my app and call the first page

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:talk_around/ui/routes.dart';

MaterialColor myPrimarySwatch = MaterialColor(0xFF013E6A, {
  50: const Color(0xFFE0F2F7),
  100: const Color(0xFFB3E0F2),
  200: const Color(0xFF80CFEC),
  300: const Color(0xFF4DBEE5),
  400: const Color(0xFF26B0E0),
  500: const Color(0xFF013E6A),
  600: const Color(0xFF0099CC),
  700: const Color(0xFF008AB3),
  800: const Color(0xFF007A99),
  900: const Color(0xFF006680),
});

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // The first page is called here
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Talk Around',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: myPrimarySwatch,
          primaryColor: const Color(0x013E6A),
        ),
        initialRoute: AppRoutes.first,
        getPages: appRoutes());
  }
}
