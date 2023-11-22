import 'dart:async';

import 'package:get/get.dart';
import 'package:talk_around/domain/models/user.dart';

// import 'package:talk_around/data/repositories/auth_firebase_repository.dart';
import 'package:talk_around/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  // final AuthFirebaseRepository _authRepository = AuthFirebaseRepository();

  // StreamSubscription<User?> subscribeAuthChanges(void Function(User?) onData) {
  //   return _authRepository.authChanges.listen(onData);
  // }
  Stream<AuthChangeData?> get authChanges => _authRepository.authChanges;

  Future<void> signIn(String email, String password) async {
    await _authRepository.signIn(email, password);
  }

  Future<void> signInWithGoogle() async {
    await _authRepository.signInWithGoogle();
  }

  Future<void> signInAsAnonymous() async {
    await _authRepository.signInAsAnonymous();
  }

  Future<User> signUp(User user) async {
    return await _authRepository.signUp(user);
  }

  Future<void> logOut() async {
    await _authRepository.logOut();
  }

  // Future<bool> isLoggedIn() async {
  //   return await _authRepository.isLoggedIn();
  // }
}
