import 'package:loggy/loggy.dart';

import 'package:talk_around/data/datasources/local/auth_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/auth_datasource.dart';
import 'package:talk_around/data/utils/network_util.dart';
import 'package:talk_around/domain/models/user.dart';

import 'package:talk_around/domain/repositories/auth_repository.dart';

class AuthFirebaseRepository implements AuthRepository {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();
  final AuthDatasource _authDatasource = AuthDatasource();

  @override
  Future<void> signIn(String email, String password) async {
    await _authDatasource.signIn(email, password);
  }

  @override
  Future<void> signInWithGoogle() async {
    await _authDatasource.signInWithGoogle();
  }

  @override
  Future<void> signInAsAnonymous() async {
    try {
      await _authDatasource.signInAsAnonymous();
    } catch (err) {
      logError(err);
      if (!(await NetworkUtil.hasNetwork())) {
        await _authLocalDatasource.signInAsAnonymous();
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<User> signUp(User user) async {
    return await _authDatasource.signUp(user);
  }

  @override
  Future<void> logOut() async {
    if (await _authLocalDatasource.containsToken()) {
      await _authLocalDatasource.logOut();
    }
    await _authDatasource.logOut();
  }

  @override
  Future<bool> isLoggedIn() async {
    // if (await _authDatasource.isLoggedIn()) return true;
    if (await NetworkUtil.hasNetwork()) {
      return await _authDatasource.isLoggedIn();
    } else {
      return await _authLocalDatasource.isLoggedIn();
    }
  }
}
