import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  static const List<String> scopes = [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
  );

  Future<GoogleSignInAuthentication?> signIn() async {
    // if (!await _googleSignIn.canAccessScopes(scopes)) {
    //   await _googleSignIn.requestScopes(scopes);
    // }
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    return await account?.authentication;
  }

  Future<String?> signOut() async {
    final GoogleSignInAccount? account = await _googleSignIn.signOut();
    return account?.email;
  }
}
