

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:talk_around/main.dart';
// import 'package:get/get.dart';
// import 'package:talk_around/ui/controllers/app_controller.dart';
// import 'package:talk_around/ui/pages/first_page.dart';
// import 'package:talk_around/domain/use_cases/auth_use_case.dart';
// import 'package:talk_around/domain/repositories/auth_repository.dart';
// import 'package:talk_around/data/repositories/auth_firebase_repository.dart';

// void main() {
//   setUp(() {
//     Get.put<AuthRepository>(AuthFirebaseRepository());
//     Get.put(AuthUseCase());
//     Get.put(AppController());
//   });

//   testWidgets('FirstPage UI Test', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       MaterialApp(
//         home: FirstPage(),
//       ),
//     );
//     expect(find.byType(FirstPage), findsOneWidget);
//     expect(find.text('Chat with Locals'), findsOneWidget);
//     expect(find.text('Anywhere, anytime'), findsOneWidget);

//     await tester.tap(find.byKey(const Key('getStartedButton')));
//     await tester.pumpAndSettle();
//     expect(find.byType(FirstPage), findsNothing);
//   });
// }
