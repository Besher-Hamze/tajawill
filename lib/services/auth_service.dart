// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential creds = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return creds.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential creds = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return creds.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
