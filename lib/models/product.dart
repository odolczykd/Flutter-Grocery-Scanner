import 'package:grocery_scanner/models/product_images.dart';
import 'package:grocery_scanner/models/product_nutriments.dart';

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
        productName: json["product_name"],
        brand: json["brand"] ?? json["brands"],
        country: json["countries"],
        images: ProductImages(
            front: json["image_front_url"] ?? "",
            ingredients: json["image_ingredients_url"] ?? "",
            nutrition: json["image_nutrition_url"] ?? ""),
        ingredients:
            json["ingredients_text_pl"] ?? json["ingredients_text"] ?? "",
        allergens: json["allergens_from_ingredients"] ?? json["allergens"],
        nutriments: ProductNutriments.fromJson(json["nutriments"]),
        nutriscore: json["nutriscore_grade"]);
  }
}

bool _isPresent(var value) => !(value == null && value == "");
