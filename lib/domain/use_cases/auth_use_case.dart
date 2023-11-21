import 'package:get/get.dart';

// import 'package:talk_around/data/repositories/auth_firebase_repository.dart';
import 'package:talk_around/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  // final AuthFirebaseRepository _authRepository = AuthFirebaseRepository();

  Future<String> login(String email, String password) async =>
      await _authRepository.login(email, password);

  Future<String> loginWithGoogle() async =>
      await _authRepository.loginWithGoogle();

  Future<void> signUp(String email, String password) async =>
      await _authRepository.signUp(email, password);

  Future<void> signUpWithGoogle() async =>
      await _authRepository.signUpWithGoogle();

  Future<void> logOut() async => await _authRepository.logOut();

  Future<bool> isLoggedIn() async => await _authRepository.isLoggedIn();
}
