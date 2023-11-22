import 'package:talk_around/domain/models/user.dart';

abstract class AuthRepository {
  Future<void> signIn(String email, String password);

  Future<void> signInWithGoogle();

  Future<void> signInAsAnonymous();

  Future<User> signUp(User user);

  Future<void> logOut();

  Future<bool> isLoggedIn();
}
