import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/product/product_page.dart';
import 'package:grocery_scanner/screens/product/product_not_found.dart';
import 'package:grocery_scanner/services/open_food_facts.dart';
import 'package:grocery_scanner/services/product_database.dart';
import 'package:grocery_scanner/services/translator.dart';
import 'package:grocery_scanner/shared/loading.dart';
import 'package:provider/provider.dart';

class ProductFetcherApi extends StatefulWidget {
  final String? barcode;
  const ProductFetcherApi(this.barcode, {super.key});

  @override
  State<ProductFetcherApi> createState() => _ProductFetcherApiState();
}

class _ProductFetcherApiState extends State<ProductFetcherApi> {
  late Future<ProductResponse?> productFuture;
  String? productIngredientsTranslation;
  String? productAllergensTranslation;
  Set<String> allergens = {};

  @override
  void initState() {
    super.initState();
    if (widget.barcode == null) {
      productFuture = Future.value(null);
    } else {
      productFuture =
          OpenFoodFactsApiService.fetchProductByBarcode(widget.barcode!);
      productFuture.then((product) async {
        // Translate Product Ingredients
        final ingredientsTranslation =
            await TranslatorService.translate(product!.ingredients);
        setState(() {
          productIngredientsTranslation =
              !ingredientsTranslation.detectedSourceLang.compareIgnoreCase("PL")
                  ? ingredientsTranslation.text
                  : product.ingredients;
        });

        // Translate Product Allergens
        final allergensTranslation =
            await TranslatorService.translate(product.allergens);
        setState(() {
          productAllergensTranslation =
              !allergensTranslation.detectedSourceLang.compareIgnoreCase("PL")
                  ? allergensTranslation.text
                  : product.allergens;
        });

        // Extract Allergens from Ingredients
        final json = await _readJsonFile("assets/data/allergens.json");
        var separatedAllergens = productAllergensTranslation!
            .split(", ")
            .map((e) => e.trim())
            .toSet();
        final extractedFromIngredients =
            _separateWords(productIngredientsTranslation);
        separatedAllergens.addAll(extractedFromIngredients);

        for (String allergen in separatedAllergens) {
          for (String key in json.keys) {
            List<dynamic> keywords = json[key]["keywords"];
            for (String keyword in keywords) {
              if (RegExp("^$keyword").hasMatch(allergen)) {
                allergens.add(key);
              }
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User?>(context)!;

    return FutureBuilder(
      future: productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        if (!snapshot.hasData) {
          return const ProductNotFound();
        }

        final product = snapshot.data!;
        Product translatedProduct = Product(
            barcode: product.barcode,
            productName: product.productName,
            brand: product.brand,
            country: product.country,
            images: product.images,
            ingredients: productIngredientsTranslation ?? "",
            nutriments: product.nutriments,
            allergens: allergens,
            nutriscore: product.nutriscore);
        ProductDatabaseService(product.barcode).addProduct(translatedProduct);
        return ProductPage(translatedProduct);
      },
    );
  }
}

Future<Map<String, dynamic>> _readJsonFile(String filePath) async {
  final file = await rootBundle.loadString(filePath);
  return jsonDecode(file);
}

List<String> _separateWords(String? text) {
  const separateRuleRegex =
      r"[^\p{Alphabetic}\p{Mark}\p{Connector_Punctuation}\p{Join_Control}\s]+";
  return text == null
      ? []
      : text
          .replaceAll(RegExp(separateRuleRegex, unicode: true), "")
          .split(" ")
          .where((e) => e.isNotEmpty)
          .map((e) => e.trim())
          .map((e) => e.toLowerCase())
          .toList();
}
