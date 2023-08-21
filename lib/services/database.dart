import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/shared/rank.dart';

class DatabaseService {
  String uid;
  DatabaseService(this.uid);

  // Users Collection

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future initializeUserData({required String username}) async {
    // TODO: Fix situation: uid = null
    return await userCollection.doc(uid).set({
      "username": username,
      "rank": Rank.NEW_USER,
      "yourProducts": [],
      "recentlyScannedProducts": [],
      "pinnedProducts": [],
      "preferences": [],
      "restrictions": []
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        // uid: uid,
        username: snapshot.get("username"),
        rank: snapshot.get("rank"),
        avatar: snapshot.get("avatar"),
        yourProducts: snapshot.get("yourProducts"),
        recentlyScannedProducts: snapshot.get("recentlyScannedProducts"),
        pinnedProducts: snapshot.get("pinnedProducts"),
        preferences: snapshot.get("preferences"),
        restrictions: snapshot.get("restrictions"));
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // list all usernames in database
  // List<String> _usernamesFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs
  //       .map((doc) =>
  //           doc.get("username") == null ? "" : doc.get("username") as String)
  //       .toList();
  // }

  // Stream<List<String>> get users {
  //   return userCollection.snapshots().map(_usernamesFromSnapshot);
  // }
}
