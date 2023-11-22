import 'dart:async';

import 'package:talk_around/domain/models/user.dart';

abstract class AuthRepository {
  Stream<AuthChangeData?> get authChanges;

  Future<void> signIn(String email, String password);

  Future<void> signInWithGoogle();

  Future<void> signInAsAnonymous();

  Future<User> signUp(User user);

  Future<void> logOut();

  // Future<bool> isLoggedIn();
}

class AuthChangeData {
  final String? email;
  final bool isAnonymous;

  const AuthChangeData(this.email, this.isAnonymous);
}
