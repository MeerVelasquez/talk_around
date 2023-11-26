import 'dart:async';

import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:talk_around/data/datasources/local/auth_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/auth_datasource.dart';
import 'package:talk_around/services/network_service.dart';
import 'package:talk_around/domain/models/user.dart';

import 'package:talk_around/domain/repositories/auth_repository.dart';

class AuthFirebaseRepository implements AuthRepository {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();
  final AuthDatasource _authDatasource = AuthDatasource();

  final Rx<Stream<AuthChangeData?>> _authChanges =
      Rx<Stream<AuthChangeData?>>(const Stream.empty());

  AuthFirebaseRepository() {
    _authChanges.value =
        _authDatasource.authChanges.stream.asBroadcastStream().asyncMap((user) {
      if (user == null) {
        return null;
      } else {
        return AuthChangeData(user.email, user.isAnonymous);
      }
    });
  }

  @override
  Stream<AuthChangeData?> get authChanges => _authChanges.value;

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
      if (!(await NetworkService.hasNetwork())) {
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

  // @override
  // Future<AuthChangeData> isLoggedIn() async {
  //   final AuthChangeData? first = await _authChanges.value.first;
  //   if (first != null) {
  //     return first;
  //   }

  //   final Completer<AuthChangeData> completer = Completer<AuthChangeData>();
  //   StreamSubscription<AuthChangeData?> subs = _authChanges.value.listen((event) {
  //     logInfo('**************************: $event');
  //   });.onData((AuthChangeData? authChange) {
  //     if (authChange != null) {
  //       completer.complete(authChange);
  //     }
  //   });
  //   return completer.future;
  // }
}
