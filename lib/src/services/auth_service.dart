import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to register a new user
  Future<void> registerUser(
      String email, String password, String username, String mobile) async {
    try {
      // Encrypt the password
      String encryptedPassword = encryptPassword(password);

      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: encryptedPassword);

      result.user?.updateDisplayName(username);
      // Create a new document in Firestore for the user
      await _db
          .collection('users')
          .doc(result.user!.uid)
          .set({'username': username, 'mobile': mobile});
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

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (userDataSnapshot.exists) {
        return userDataSnapshot;
      }
    }
    return null;
  }

  bool isLoggedIn() {
    User? user = _auth.currentUser;
    return user != null;
  }

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn(
            clientId:
                "137355047885-54v37gnflplod160jpo3rv0vs1hnrd8o.apps.googleusercontent.com")
        .signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    await _db.collection('users').doc(userCredential.user!.uid).set({
      'username': userCredential.user?.displayName,
      'mobile': userCredential.user?.phoneNumber
    });
  }

  signInWithFacebook() {
    throw Exception("signInWithFacebook is not yet implemented");
  }

  Future<void> updateUserInfo(
    String username,
    String email,
    String mobile,
    String gender,
    String dateOfBirth,
    String description,
    String location,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _db.collection('users').doc(user.uid).update({
          'username': username,
          'email': email,
          'mobile': mobile,
          'gender': gender,
          'dateOfBirth': dateOfBirth,
          'description': description,
          'location': location,
        });
      }
    } catch (error) {
      print("Error updating user info: $error");
      rethrow;
    }
  }
}
