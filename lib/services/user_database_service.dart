import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_scanner/models/product.dart';

const MAX_SIZE_OF_RECENTLY_SCANNED_PRODUCTS_ARRAY = 50;

class UserDatabaseService {
  String uid;
  UserDatabaseService(this.uid);

  // Users Collection

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future initializeUserData(
      {required String username, required String displayName}) async {
    // TODO: Fix situation: uid = null
    return await userCollection.doc(uid).set({
      "username": username,
      "display_name": displayName,
      "preferences": [],
      "restrictions": [],
      "recently_scanned_products": [],
      "pinned_products": [],
      "your_products": [],
      "created_at_timestamp": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future relateUserWithProduct(String barcode) async {
    var documentSnapshot = await userCollection.doc(uid).get();
    List<dynamic> yourProducts = documentSnapshot.get("your_products");
    yourProducts.add(barcode);
    await userCollection.doc(uid).update({"your_products": yourProducts});
  }

  Future<bool> checkIfProductBelongsToUser(Product product) async {
    var documentSnapshot = await userCollection.doc(uid).get();
    List<dynamic> yourProducts = documentSnapshot.get("your_products");
    return yourProducts.contains(product.barcode);
  }

  Future<bool> checkIfProductIsPinned(Product product) async {
    var documentSnapshot = await userCollection.doc(uid).get();
    List<dynamic> pinnedProducts = documentSnapshot.get("pinned_products");
    return pinnedProducts.contains(product.barcode);
  }

  Future<Product?> pinProduct(Product product, [String mode = "pin"]) async {
    try {
      var documentSnapshot = await userCollection.doc(uid).get();
      List<dynamic> pinnedProducts = documentSnapshot.get("pinned_products");
      if (mode == "pin") {
        pinnedProducts.add(product.barcode);
      } else if (mode == "unpin") {
        pinnedProducts.remove(product.barcode);
      } else {
        return null;
      }

      await userCollection.doc(uid).update({"pinned_products": pinnedProducts});
      return product;
    } on Exception {
      return null;
    } on Error {
      return null;
    }
  }

  Future<bool> addProductToRecentlyScanned(Product product) async {
    final barcode = product.barcode;

    try {
      var documentSnapshot = await userCollection.doc(uid).get();
      List<dynamic> recentlyScannedProducts =
          documentSnapshot.get("recently_scanned_products");

      if (recentlyScannedProducts.contains(barcode)) {
        recentlyScannedProducts.remove(barcode);
        recentlyScannedProducts.insert(0, barcode);

        await userCollection
            .doc(uid)
            .update({"recently_scanned_products": recentlyScannedProducts});
        return true;
      }

      if (recentlyScannedProducts.length >=
          MAX_SIZE_OF_RECENTLY_SCANNED_PRODUCTS_ARRAY) {
        recentlyScannedProducts.removeLast();
      }
      recentlyScannedProducts.insert(0, barcode);

      await userCollection
          .doc(uid)
          .update({"recently_scanned_products": recentlyScannedProducts});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateField(String fieldName, Object value) async {
    try {
      await userCollection.doc(uid).update({fieldName: value});
      return true;
    } on Exception {
      return false;
    } on Error {
      return false;
    }
  }

  Future<bool> deleteDocument() async {
    try {
      await userCollection.doc(uid).delete();
      return true;
    } on Exception {
      return false;
    } on Error {
      return false;
    }
  }

  // UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
  //   return UserData(
  //       // uid: uid,
  //       username: snapshot.get("username"),
  //       displayName: snapshot.get("display_name"),
  //       preferences: snapshot.get("preferences"),
  //       restrictions: snapshot.get("restrictions"),
  //       yourProducts: snapshot.get("your_products"),
  //       recentlyScannedProducts: snapshot.get("recently_scanned_products"),
  //       pinnedProducts: snapshot.get("pinned_products"),
  //       createdAtTimestamp: snapshot.get("created_at_timestamp"));
  // }

  // Stream<UserData> get userData {
  //   return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  // }

  Future<List> getFieldByName(String fieldName) async {
    var documentSnapshot = await userCollection.doc(uid).get();
    return documentSnapshot.get(fieldName);
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
