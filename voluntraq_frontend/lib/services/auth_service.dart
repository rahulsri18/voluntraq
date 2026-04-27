import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Register with Email & Password
  static Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
    required String dob,
    String role = 'volunteer',
    String? ngoName,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user data to Realtime Database
      if (result.user != null) {
        await _db.ref('users/${result.user!.uid}').set({
          'name': name,
          'email': email,
          'dob': dob,
          'role': role,
          'ngoName': ngoName,
          'createdAt': ServerValue.timestamp,
        });
      }

      return result;
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  // Login with Email & Password
  static Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Get Current User Role
  static Future<String> getUserRole(String uid) async {
    final snapshot = await _db.ref('users/$uid/role').get();
    return snapshot.value as String? ?? 'volunteer';
  }

  // Error Handler
  static String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'user-not-found':
          return 'No user found with this email.';
        case 'weak-password':
          return 'The password is too weak.';
        default:
          return e.message ?? 'An unknown error occurred.';
      }
    }
    return e.toString();
  }
}
