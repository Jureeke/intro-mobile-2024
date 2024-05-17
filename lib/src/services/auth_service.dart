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

  signOut() {
    _auth.signOut();
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

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getClubs() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('clubs').get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getClubReservations(
      String clubID) async {
    DocumentReference clubRef =
        FirebaseFirestore.instance.collection('clubs').doc(clubID);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('reservations')
        .where('clubRef', isEqualTo: clubRef)
        .get();
    return querySnapshot.docs;
  }

  Future<List<Map<String, dynamic>>> getAllPublicReservations() async {
    DateTime currentDate = DateTime.now().add(const Duration(hours: 1));
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('reservations')
        .where('reservationDateTime',
            isGreaterThan: Timestamp.fromDate(currentDate))
        .get();

    List<Map<String, dynamic>> reservations = [];

    for (var reservationDoc in querySnapshot.docs) {
      Map<String, dynamic> reservationData = reservationDoc.data();
      reservationData['id'] = reservationDoc.id;

      DocumentReference clubRef = reservationData['clubRef'];
      DocumentReference? userHomeLeftRef = reservationData['userHomeLeftRef'];
      DocumentReference? userHomeRightRef = reservationData['userHomeRightRef'];
      DocumentReference? userAwayLeftRef = reservationData['userAwayLeftRef'];
      DocumentReference? userAwayRightRef = reservationData['userAwayRightRef'];

      if (userHomeLeftRef != null) {
        DocumentSnapshot<Map<String, dynamic>> userHomeLeftSnapshot =
            await userHomeLeftRef.get()
                as DocumentSnapshot<Map<String, dynamic>>;

        if (userHomeLeftSnapshot.exists) {
          Map<String, dynamic> data = userHomeLeftSnapshot.data()!;
          reservationData['userHomeLeft'] = data;
        }
      }
      if (userHomeRightRef != null) {
        DocumentSnapshot<Map<String, dynamic>> userHomeRightSnapshot =
            await userHomeRightRef.get()
                as DocumentSnapshot<Map<String, dynamic>>;
        if (userHomeRightSnapshot.exists) {
          Map<String, dynamic> userHomeRightData =
              userHomeRightSnapshot.data()!;
          reservationData['userHomeRight'] = userHomeRightData;
        }
      }
      if (userAwayLeftRef != null) {
        DocumentSnapshot<Map<String, dynamic>> userAwayLeftSnapshot =
            await userAwayLeftRef.get()
                as DocumentSnapshot<Map<String, dynamic>>;
        if (userAwayLeftSnapshot.exists) {
          Map<String, dynamic> userAwayLeftData = userAwayLeftSnapshot.data()!;
          reservationData['userAwayLeft'] = userAwayLeftData;
        }
      }
      if (userAwayRightRef != null) {
        DocumentSnapshot<Map<String, dynamic>> userAwayRightSnapshot =
            await userAwayRightRef.get()
                as DocumentSnapshot<Map<String, dynamic>>;
        if (userAwayRightSnapshot.exists) {
          Map<String, dynamic> userAwayRightData =
              userAwayRightSnapshot.data()!;
          reservationData['userAwayRight'] = userAwayRightData;
        }
      }

      DocumentSnapshot<Map<String, dynamic>> clubSnapshot =
          await clubRef.get() as DocumentSnapshot<Map<String, dynamic>>;
      if (clubSnapshot.exists) {
        Map<String, dynamic> data = clubSnapshot.data()!;
        reservationData['club'] = data;
      }
      if (reservationData['isPublic']) {
        reservations.add(reservationData);
      }
    }
    reservations.sort((a, b) => (a['reservationDateTime'] as Timestamp)
        .toDate()
        .compareTo((b['reservationDateTime'] as Timestamp).toDate()));
    return reservations;
  }

  Future<void> bookCourt(
    String clubID,
    int court,
    bool isPublic,
    DateTime reservationDateTime,
  ) async {
    try {
      DocumentReference clubRef =
          FirebaseFirestore.instance.collection('clubs').doc(clubID);
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentReference? userRef = getUserRef();
        await _db.collection('reservations').doc().set({
          'clubRef': clubRef,
          'court': court,
          'isPublic': isPublic,
          'reservationDateTime': reservationDateTime,
          'userRef': userRef,
          'userHomeLeftRef': userRef,
          'userHomeRightRef': null,
          'userAwayLeftRef': null,
          'userAwayRightRef': null,
        });
      }
    } catch (error) {
      print("Error creating booking: $error");
      rethrow;
    }
  }

  DocumentReference? getUserRef() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _db.collection('users').doc(user.uid);
    }
    return null;
  }

  User? getUser() {
    return _auth.currentUser;
  }

  Future<void> joinMatch(
    String reservationID,
    Map<String, DocumentReference?> position,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _db
            .collection('reservations')
            .doc(reservationID)
            .set(position, SetOptions(merge: true));
      }
    } catch (error) {
      print("Error joining match: $error");
      rethrow;
    }
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
