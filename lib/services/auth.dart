import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/services/user_database.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Auth Change User Stream
  Stream<User?> get user {
    return _auth.authStateChanges().map(_convertFirebaseUserToCustomUser);
  }

  String? get currentUserUid {
    return _auth.currentUser?.uid;
  }

  // convert Firebase User to Custom User object
  User? _convertFirebaseUserToCustomUser(firebase_auth.User? user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // sign in anon
  // Future signInAnon() async {
  //   try {
  //     firebase_auth.UserCredential result = await _auth.signInAnonymously();
  //     firebase_auth.User? user = result.user;
  //     return _convertFirebaseUserToCustomUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // sign in email + pass
  Future signIn(String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      firebase_auth.User? user = result.user;
      return _convertFirebaseUserToCustomUser(user);
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  // register email + pass
  Future register(String username, String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      firebase_auth.User? user = result.user;
      await UserDatabaseService(user!.uid)
          .initializeUserData(username: username);
      return _convertFirebaseUserToCustomUser(user);
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
