import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/shared/rank.dart';

class UserDatabaseService {
  String uid;
  UserDatabaseService(this.uid);

  // Users Collection

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future initializeUserData({required String username}) async {
    // TODO: Fix situation: uid = null
    return await userCollection.doc(uid).set({
      "username": username,
      "rank": Rank.newUser.desc,
      "yourProducts": [],
      "recentlyScannedProducts": [],
      "pinnedProducts": [],
      "preferences": [],
      "restrictions": [],
      "createdAt": DateTime.now()
    });
  }

  Future pinProduct(Product product, [String mode = "pin"]) async {
    var documentSnapshot = await userCollection.doc(uid).get();
    List<dynamic> pinnedProducts = documentSnapshot.get("pinnedProducts");
    if (mode == "pin") {
      pinnedProducts.add(product);
    } else if (mode == "unpin") {
      pinnedProducts.remove(product);
    } else {
      return;
    }
    return await userCollection
        .doc(uid)
        .update({"pinnedProducts": pinnedProducts});
    // .set({"pinnedProducts": pinnedProducts});
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
        restrictions: snapshot.get("restrictions"),
        createdAt: snapshot.get("createdAt"));
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
