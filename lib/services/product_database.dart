import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_scanner/models/product_images.dart';
import 'package:grocery_scanner/models/product_nutriments.dart';

import '../models/product.dart';

class ProductDatabaseService {
  String barcode;
  ProductDatabaseService(this.barcode);

  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection("products");

  Future addProduct(Product product) async {
    final productJson = product.toJson();
    return await productsCollection.doc(barcode).set(productJson);
  }

  Future<Product?> getProduct() async {
    final product = await productsCollection.doc(barcode).get();
    if (!product.exists) return null;

    return Product(
        barcode: product.get("barcode"),
        productName: product.get("product_name"),
        brand: product.get("brand"),
        country: product.get("country"),
        images: ProductImages(
            front: product.get("images")["front"],
            ingredients: product.get("images")["ingredients"],
            nutrition: product.get("images")["nutrition"]),
        ingredients: product.get("ingredients"),
        nutriments: ProductNutriments(energyKJ: {
          "value": product.get("nutriments")["energy_KJ"]["value"],
          "value_100g": product.get("nutriments")["energy_KJ"]["value_100g"]
        }, energyKcal: {
          "value": product.get("nutriments")["energy_kcal"]["value"],
          "value_100g": product.get("nutriments")["energy_kcal"]["value_100g"]
        }, fat: {
          "value": product.get("nutriments")["fat"]["value"],
          "value_100g": product.get("nutriments")["fat"]["value_100g"]
        }, saturatedFat: {
          "value": product.get("nutriments")["saturated_fat"]["value"],
          "value_100g": product.get("nutriments")["saturated_fat"]["value_100g"]
        }, carbohydrates: {
          "value": product.get("nutriments")["carbohydrates"]["value"],
          "value_100g": product.get("nutriments")["carbohydrates"]["value_100g"]
        }, sugars: {
          "value": product.get("nutriments")["sugars"]["value"],
          "value_100g": product.get("nutriments")["sugars"]["value_100g"]
        }, proteins: {
          "value": product.get("nutriments")["proteins"]["value"],
          "value_100g": product.get("nutriments")["proteins"]["value_100g"]
        }, salt: {
          "value": product.get("nutriments")["salt"]["value"],
          "value_100g": product.get("nutriments")["salt"]["value_100g"]
        }),
        allergens: (product.get("allergens") as List).toSet(),
        nutriscore: product.get("nutriscore"));
  }
}
