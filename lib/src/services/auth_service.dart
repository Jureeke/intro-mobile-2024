import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to register a new user
  Future<void> registerUser(
      String email, String password, String username) async {
    try {
      // Encrypt the password
      String encryptedPassword = encryptPassword(password);

      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: encryptedPassword);

      // Create a new document in Firestore for the user
      await _db
          .collection('users')
          .doc(result.user!.uid)
          .set({'username': username});
    } catch (error) {
      print("Error registering user: $error");
      rethrow;
    }
  }

  // Method to login user
  Future<void> loginUser(String email, String password) async {
    try {
      // Encrypt the password
      String encryptedPassword = encryptPassword(password);

      // Sign in user with email and password
      await _auth.signInWithEmailAndPassword(
          email: email, password: encryptedPassword);
    } catch (error) {
      print("Error logging in: $error");
      rethrow;
    }
  }

  // Method to encrypt password
  String encryptPassword(String password) {
    const key =
        'my_secret_key'; // You should use a secure key management solution
    final hmacSha256 =
        Hmac(sha256, utf8.encode(key)); // Create a HMAC-SHA256 object
    final digest =
        hmacSha256.convert(utf8.encode(password)); // Calculate the digest
    return digest.toString(); // Convert digest to string and return
  }

  Future<String?>? getCurrentUserUsername() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      return userDataSnapshot.exists
          ? userDataSnapshot.data()!['username']
          : null;
    }
    return null;
  }

  bool isLoggedIn() {
    User? user = _auth.currentUser;
    return user != null;
  }
}
