import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/services/user_database_service.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Auth Change User Stream
  Stream<User?> get user =>
      _auth.authStateChanges().map(_convertFirebaseUserToCustomUser);

  String? get currentUserUid => _auth.currentUser?.uid;

  User? _convertFirebaseUserToCustomUser(firebase_auth.User? user) =>
      user != null ? User(uid: user.uid) : null;

  Future signIn(String email, String password) async {
    try {
      firebase_auth.UserCredential result =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return null;
    }
  }

  Future register(String username, String displayName, String email,
      String password) async {
    try {
      firebase_auth.UserCredential result =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebase_auth.User? user = result.user;
      await UserDatabaseService(user!.uid).initializeUserData(
        username: username,
        displayName: displayName,
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteAccount(String email, String password) async {
    try {
      final user = _auth.currentUser!;
      final credentials = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      final result = await user.reauthenticateWithCredential(credentials);

      await UserDatabaseService(result.user!.uid).deleteDocument();
      await result.user!.delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
