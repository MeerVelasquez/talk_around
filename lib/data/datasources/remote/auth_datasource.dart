import 'dart:async';

import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:talk_around/domain/models/user.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthDatasource {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'user';

  final Rx<firebase_auth.User?> authChanges = Rx<firebase_auth.User?>(null);

  AuthDatasource() {
    _auth.authStateChanges().listen((firebase_auth.User? user) {
      authChanges.value = user;
    });
  }

  Future<void> signIn(String email, String password) async {
    // validate user existance in Firestore
    List<User> users = await _getUsers({'email': email});
    if (users.length != 1) {
      return Future.error('${users.length} users with email $email}');
    }
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<User?> signInWithGoogle(dynamic authentication) async {
    firebase_auth.OAuthCredential credential =
        firebase_auth.GoogleAuthProvider.credential(
      accessToken: authentication?.accessToken,
      idToken: authentication?.idToken,
    );

    firebase_auth.UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    if (userCredential.user != null && userCredential.user!.email != null) {
      final List<User> users =
          await _getUsers({'email': userCredential.user!.email});
      if (users.length > 1) {
        return Future.error(
            'More than one user with email ${userCredential.user!.email}');
      }

      final User newUser;
      if (users.isEmpty) {
        newUser = User.defaultUser();
        newUser.email = userCredential.user!.email!;
        if (userCredential.user!.displayName! != null) {
          newUser.name = userCredential.user!.displayName!;
        }

        DocumentReference doc =
            await _db.collection(_collection).add(newUser.toJson());

        newUser.id = doc.id;
      } else {
        newUser = users[0];
      }
      return newUser;
    }
    return null;
  }

  Future<void> signInAsAnonymous() async {}

  Future<User> signUp(User user) async {
    final List<User> users = await _getUsers({'email': user.email});
    if (users.length > 1) {
      return Future.error('More than one user with email ${user.email}');
    }

    final User newUser;
    if (users.isEmpty) {
      DocumentReference doc =
          await _db.collection(_collection).add(user.toJson());
      newUser = User.from(user);
      newUser.id = doc.id;
    } else {
      newUser = users[0];
    }

    await _auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password!);

    return newUser;
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  // Future<bool> isLoggedIn() async {
  //   return _isLoggedIn.value;
  // }

  Future<List<User>> _getUsers(Map<String, dynamic> filter) async {
    try {
      Query query = _db.collection(_collection);
      for (String key in filter.keys) {
        query = query.where(key, isEqualTo: filter[key]);
      }

      return (await query.get()).docs.map((doc) {
        Map<String, dynamic> userMap = doc.data() as Map<String, dynamic>;
        userMap['id'] = doc.id;
        return User.fromJson(userMap);
      }).toList();
    } catch (err) {
      return [];
    }
  }
}
