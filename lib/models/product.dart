import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product_images.dart';
import 'package:grocery_scanner/models/product_nutriments.dart';
import 'package:grocery_scanner/services/translator.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:translator/translator.dart';

class Product {
  final String id;
  final String barcode;
  final String productName;
  final String brand;
  final String country;
  final ProductImages images;
  final String ingredients;
  final ProductNutriments nutriments;
  final String allergens;
  final String nutriscore;

  Product(
      {required this.id,
      required this.barcode,
      required this.productName,
      required this.brand,
      required this.country,
      required this.images,
      required this.ingredients,
      required this.nutriments,
      required this.allergens,
      required this.nutriscore});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: "1",
        barcode: json["code"],
        productName: json["product_name"] ?? json["product_name_pl"] ?? "N/A",
        brand: json["brand"] ?? json["brands"] ?? "N/A",
        country: json["countries"] ?? "N/A",
        images: ProductImages(
            front: json["image_front_url"] ?? "",
            ingredients: json["image_ingredients_url"] ?? "",
            nutrition: json["image_nutrition_url"] ?? ""),
        ingredients:
            json["ingredients_text_pl"] ?? json["ingredients_text"] ?? "",
        allergens:
            json["allergens"] ?? json["allergens_from_ingredients"] ?? "",
        nutriments: ProductNutriments.fromJson(json["nutriments"]),
        nutriscore: json["nutriscore_grade"] ?? "unknown");
  }

  Widget translateIngredients() {
    return FutureBuilder(
        future: Translator.translate(ingredients),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final translation = snapshot.data!;
            if (translation.detectedSourceLang == "pl") {
              return Text(ingredients);
            } else {
              return Text(snapshot.data!.text);
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Wczytywanie...");
          } else {
            return Column(
              children: [
                const Text(
                    "Błąd tłumaczenia! Skład może zawierać oryginalną pisownię!",
                    style: TextStyle(color: red)),
                Text(ingredients)
              ],
            );
          }
        });
  }

  Widget translateAllergens() {
    if (allergens.isEmpty) {
      return const Text("Ten produkt nie zawiera alergenów.",
          style: TextStyle(fontStyle: FontStyle.italic));
    }

    final String allergensExtracted =
        allergens.split(",").map((e) => e.trim()).map((e) {
      try {
        return e.split(":")[1];
      } on RangeError {
        return e;
      }
    }).join(", ");

    return FutureBuilder(
        future: Translator.translate(allergensExtracted),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.text);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Wczytywanie...");
          } else {
            return Column(
              children: [
                const Text(
                    "Błąd tłumaczenia! Spis alergenów może zawierać oryginalną pisownię!",
                    style: TextStyle(color: red)),
                Text(allergensExtracted)
              ],
            );
          }
        });
  }
}
