import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product_images.dart';
import 'package:grocery_scanner/models/product_nutriments.dart';
import 'package:grocery_scanner/services/translator.dart';
import 'package:grocery_scanner/shared/colors.dart';

class Product {
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
      {required this.barcode,
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

  Map<String, dynamic> toJson() => {
        "barcode": barcode,
        "product_name": productName,
        "brand": brand,
        "country": country,
        "images": {
          "front": images.front,
          "ingredients": images.ingredients,
          "nutrition": images.nutrition
        },
        "ingredients": ingredients,
        "allergens": allergens,
        "nutriments": {
          "energy_KJ": {
            "value": nutriments.energyKJ["value"],
            "value_100g": nutriments.energyKJ["value_100g"],
          },
          "energy_kcal": {
            "value": nutriments.energyKcal["value"],
            "value_100g": nutriments.energyKcal["value_100g"],
          },
          "fat": {
            "value": nutriments.fat["value"],
            "value_100g": nutriments.fat["value_100g"],
          },
          "saturated_fat": {
            "value": nutriments.saturatedFat["value"],
            "value_100g": nutriments.saturatedFat["value_100g"],
          },
          "carbohydrates": {
            "value": nutriments.carbohydrates["value"],
            "value_100g": nutriments.carbohydrates["value_100g"],
          },
          "sugars": {
            "value": nutriments.sugars["value"],
            "value_100g": nutriments.sugars["value_100g"],
          },
          "proteins": {
            "value": nutriments.proteins["value"],
            "value_100g": nutriments.proteins["value_100g"],
          },
          "salt": {
            "value": nutriments.salt["value"],
            "value_100g": nutriments.salt["value_100g"],
          },
        },
        "nutriscore": nutriscore,
      };

  Widget translateIngredients() {
    return FutureBuilder(
        future: Translator.translate(ingredients),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.text,
                style: const TextStyle(fontSize: 15.0));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Wczytywanie...");
          } else {
            return Column(
              children: [
                const Text(
                    "Brak tłumaczenia! Skład może zawierać oryginalną pisownię",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: red,
                        fontStyle: FontStyle.italic)),
                Text(ingredients)
              ],
            );
          }
        });
  }

  Widget translateAllergens() {
    if (allergens.isEmpty) {
      return const Text("Ten produkt nie zawiera alergenów.",
          style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic));
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
