import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timywebapp/models/userChannelLink.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  User user;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Stream<UserChannelLink> streamData() {
    user = _firebaseAuth.currentUser;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .map((event) => UserChannelLink.fromDocument(event));
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'signded in';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
