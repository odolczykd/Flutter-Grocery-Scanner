import 'package:grocery_scanner/models/product_images.dart';
import 'package:grocery_scanner/models/product_nutriments.dart';

class Product {
  final String barcode;
  final String productName;
  final String brand;
  final String country;
  final ProductImages images;
  final String ingredients;
  final ProductNutriments nutriments;
  final Set<dynamic> allergens;
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
}

class ProductResponse {
  final String barcode;
  final String productName;
  final String brand;
  final String country;
  final ProductImages images;
  final String ingredients;
  final ProductNutriments nutriments;
  final String allergens;
  final String nutriscore;

  ProductResponse(
      {required this.barcode,
      required this.productName,
      required this.brand,
      required this.country,
      required this.images,
      required this.ingredients,
      required this.nutriments,
      required this.allergens,
      required this.nutriscore});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
        barcode: json["code"],
        productName: _getFirstNonEmptyValue(json, r"^product_name_", "N/A"),
        brand: _getFirstNonEmptyValue(json, r"^brand", "N/A"),
        country: json["countries"] ?? "N/A",
        images: ProductImages(
            front: json["image_front_url"] ?? "",
            ingredients: json["image_ingredients_url"] ?? "",
            nutrition: json["image_nutrition_url"] ?? ""),
        ingredients: _getFirstNonEmptyValue(json, r"^ingredients_text"),
        allergens: _getFirstNonEmptyValue(json, r"^allergens"),
        nutriments: ProductNutriments.fromJson(json["nutriments"]),
        nutriscore: json["nutriscore_grade"] ?? "unknown");
  }
}

String _getFirstNonEmptyValue(Map<String, dynamic> json, String pattern,
    [String emptyValue = ""]) {
  List<String> filteredEntries = json.entries
      .where((entry) => RegExp(pattern).hasMatch(entry.key))
      .map((element) => element.value.toString())
      .toList();

  for (String entry in filteredEntries) {
    if (entry != "") return entry;
  }
  return emptyValue;
}
