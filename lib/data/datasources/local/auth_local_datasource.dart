class AuthLocalDatasource {
  Future<String> login(String email, String password) async {}

  Future<String> loginWithGoogle() async {}

  Future<void> signUp(String email, String password) async {}

  Future<void> signUpWithGoogle() async {}

  Future<bool> logOut() async {}

  Future<bool> isLoggedIn() async {}
}
