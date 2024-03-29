// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_scanner/models/product.dart';

const MAX_SIZE_OF_RECENTLY_SCANNED_PRODUCTS_ARRAY = 50;
const ALLOW_EDIT_DAYS_THRESHOLD = 14;

class UserDatabaseService {
  String uid;
  UserDatabaseService(this.uid);

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future initializeUserData({
    required String emailAddress,
    required String displayName,
  }) async {
    return await userCollection.doc(uid).set({
      "email_address": emailAddress,
      "display_name": displayName,
      "preferences": [],
      "restrictions": [],
      "recently_scanned_products": [],
      "pinned_products": [],
      "your_products": [],
      "created_at_timestamp":
          (DateTime.now().millisecondsSinceEpoch / 1000).round()
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

  Future<bool> checkIfUserCanEditProduct() async {
    var documentSnapshot = await userCollection.doc(uid).get();
    int createdAtTimestamp = documentSnapshot.get("created_at_timestamp");
    num difference =
        (DateTime.now().millisecondsSinceEpoch / 1000) - createdAtTimestamp;
    int days = (difference / (60 * 60 * 24)).floor();

    return days >= ALLOW_EDIT_DAYS_THRESHOLD;
  }

  Future<bool> checkIfProductIsPinned(Product product) async {
    var documentSnapshot = await userCollection.doc(uid).get();
    List<dynamic> pinnedProducts = documentSnapshot.get("pinned_products");
    return pinnedProducts.contains(product.barcode);
  }

  Future<bool> pinProduct(String productBarcode, [String mode = "pin"]) async {
    try {
      var documentSnapshot = await userCollection.doc(uid).get();
      List<dynamic> pinnedProducts = documentSnapshot.get("pinned_products");
      if (mode == "pin") {
        pinnedProducts.add(productBarcode);
      } else if (mode == "unpin") {
        pinnedProducts.remove(productBarcode);
      } else {
        return false;
      }

      await userCollection.doc(uid).update({"pinned_products": pinnedProducts});
      return true;
    } on Exception {
      return false;
    } on Error {
      return false;
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

  Future<List> getFieldByName(String fieldName) async {
    var documentSnapshot = await userCollection.doc(uid).get();
    return documentSnapshot.get(fieldName);
  }
}
