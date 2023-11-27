import 'dart:async';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:talk_around/domain/models/user.dart';

// import 'package:talk_around/data/repositories/auth_firebase_repository.dart';
import 'package:talk_around/domain/repositories/auth_repository.dart';
import 'package:talk_around/services/google_service.dart';

class AuthUseCase {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  // final AuthFirebaseRepository _authRepository = AuthFirebaseRepository();

  final GoogleService _googleService = Get.find<GoogleService>();

  Stream<AuthChangeData?> get authChanges => _authRepository.authChanges;

  Future<void> signIn(String email, String password) async {
    await _authRepository.signIn(email, password);
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAuthentication? authentication =
        await _googleService.signIn();
    return await _authRepository.signInWithGoogle(authentication);
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

  Future<String?> signOutGoogle() async {
    return await _googleService.signOut();
  }

  // Future<bool> isLoggedIn() async {
  //   return await _authRepository.isLoggedIn();
  // }
}
