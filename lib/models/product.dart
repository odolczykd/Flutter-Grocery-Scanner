import 'package:grocery_scanner/models/product_images.dart';
import 'package:grocery_scanner/models/product_nutriments.dart';
import 'package:hive/hive.dart';

part 'product.g.dart';

class Product {
  final String barcode;
  final String productName;
  final String brand;
  final ProductImages images;
  final String ingredients;
  final ProductNutriments nutriments;
  final Set allergens;
  final String nutriscore;
  final List tags;

  Product({
    required this.barcode,
    required this.productName,
    required this.brand,
    required this.images,
    required this.ingredients,
    required this.nutriments,
    required this.allergens,
    required this.nutriscore,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
        "barcode": barcode,
        "product_name": productName,
        "brand": brand,
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
        "tags": tags
      };
}

@HiveType(typeId: 0)
class ProductOffline {
  @HiveField(0)
  final String barcode;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final String brand;

  @HiveField(3)
  final ProductOfflineImages images;

  @HiveField(4)
  final String ingredients;

  @HiveField(5)
  final ProductNutriments nutriments;

  @HiveField(6)
  final Set allergens;

  @HiveField(7)
  final String nutriscore;

  @HiveField(8)
  final List tags;

  ProductOffline({
    required this.barcode,
    required this.productName,
    required this.brand,
    required this.images,
    required this.ingredients,
    required this.nutriments,
    required this.allergens,
    required this.nutriscore,
    required this.tags,
  });
}

class ProductResponse {
  final String barcode;
  final String productName;
  final String brand;
  final ProductImages images;
  final String ingredients;
  final ProductNutriments nutriments;
  final String allergens;
  final String nutriscore;
  final List tags;

  ProductResponse({
    required this.barcode,
    required this.productName,
    required this.brand,
    required this.images,
    required this.ingredients,
    required this.nutriments,
    required this.allergens,
    required this.nutriscore,
    required this.tags,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      barcode: json["code"],
      productName: _getFirstNonEmptyValue(json, r"^product_name_", "N/A"),
      brand: _getFirstNonEmptyValue(json, r"^brand", "N/A"),
      images: ProductImages(
          front: json["image_front_url"] ?? "",
          ingredients: json["image_ingredients_url"] ?? "",
          nutrition: json["image_nutrition_url"] ?? ""),
      ingredients: _getFirstNonEmptyValue(json, r"^ingredients_text"),
      allergens: _getFirstNonEmptyValue(json, r"^allergens"),
      nutriments: ProductNutriments.fromJson(json["nutriments"]),
      nutriscore: json["nutriscore_grade"] ?? "unknown",
      tags: _extractTags(json["ingredients_analysis_tags"] ?? []),
    );
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

List _extractTags(List rawTags) {
  String PALM_OIL_PATTERN = r"palm-oil";
  String VEGETARIAN_PATTERN = r"vegetarian";
  String VEGAN_PATTERN = r"vegan";

  String FREE_PATTERN = r"free";
  String NON_PATTERN = r"non-";
  String MAYBE_PATTERN = r"maybe-";

  List<Map<String, String>> tags = [
    {"name": "palm_oil_free", "status": "unknown"},
    {"name": "vegetarian", "status": "unknown"},
    {"name": "vegan", "status": "unknown"}
  ];

  List<String> rawTagsTrimmed = rawTags.map((tag) {
    try {
      return (tag as String).split(":")[1];
    } on RangeError {
      return tag as String;
    }
  }).toList();

  for (String tag in rawTagsTrimmed) {
    if (RegExp(PALM_OIL_PATTERN).hasMatch(tag)) {
      if (tag == "palm-oil") tags[0]["status"] = "negative";
      if (RegExp(FREE_PATTERN).hasMatch(tag)) tags[0]["status"] = "positive";
    } else if (RegExp(VEGETARIAN_PATTERN).hasMatch(tag)) {
      if (RegExp(NON_PATTERN).hasMatch(tag)) tags[1]["status"] = "negative";
      if (RegExp(MAYBE_PATTERN).hasMatch(tag)) tags[1]["status"] = "maybe";
      if (tag == "vegetarian") tags[1]["status"] = "positive";
    } else if (RegExp(VEGAN_PATTERN).hasMatch(tag)) {
      if (RegExp(NON_PATTERN).hasMatch(tag)) tags[2]["status"] = "negative";
      if (RegExp(MAYBE_PATTERN).hasMatch(tag)) tags[2]["status"] = "maybe";
      if (tag == "vegan") tags[2]["status"] = "positive";
    } else {}
  }

  return tags;
}
