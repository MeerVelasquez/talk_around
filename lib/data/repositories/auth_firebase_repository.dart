import 'package:talk_around/data/datasources/local/auth_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/auth_datasource.dart';

import 'package:talk_around/domain/repositories/auth_repository.dart';

class AuthFirebaseRepository implements AuthRepository {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();
  final AuthDatasource _authDatasource = AuthDatasource();

  Future<String> login(String email, String password) async {}

  Future<String> loginWithGoogle() async {}

  Future<void> signUp(String email, String password) async {}

  Future<void> signUpWithGoogle() async {}

  Future<bool> logOut() async {}

  Future<bool> isLoggedIn() async {}
}
