abstract class AuthRepository {
  Future<String> login(String email, String password);

  Future<String> loginWithGoogle();

  Future<void> signUp(String email, String password);

  Future<void> signUpWithGoogle();

  Future<bool> logOut();

  Future<bool> isLoggedIn();
}
