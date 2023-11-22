import 'package:talk_around/domain/models/user.dart';

abstract class AuthRepository {
  Stream<User?> get authChanges;

  Future<void> signIn(String email, String password);

  Future<void> signInWithGoogle();

  Future<void> signInAsAnonymous();

  Future<User> signUp(User user);

  Future<void> logOut();

  Future<bool> isLoggedIn();
}
