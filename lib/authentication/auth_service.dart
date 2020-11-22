import 'package:firebase_auth/firebase_auth.dart';
import 'package:timywebapp/models/userChannel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserChannel _userFromFirebaseUser(User user) {
    return user != null ? UserChannel(id: user.uid) : null;
  }

  Stream<UserChannel> get user {
    return _auth.authStateChanges.map(_userFromFirebaseUser);
  }

  // sign in with email & password
  Future signInWithEmailAndPaswword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
