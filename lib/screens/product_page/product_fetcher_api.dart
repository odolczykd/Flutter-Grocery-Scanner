import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/screens/product_page/product_page.dart';
import 'package:grocery_scanner/screens/product_page/product_not_found.dart';
import 'package:grocery_scanner/screens/product_page/shared/allergens_functions.dart';
import 'package:grocery_scanner/services/open_food_facts_service.dart';
import 'package:grocery_scanner/services/product_database_service.dart';
import 'package:grocery_scanner/services/deepl_translator_service.dart';
import 'package:grocery_scanner/shared/allergens.dart';
import 'package:grocery_scanner/shared/error_page.dart';
import 'package:grocery_scanner/shared/loading.dart';

class ProductFetcherApi extends StatelessWidget {
  final String? barcode;
  const ProductFetcherApi(this.barcode, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: OpenFoodFactsApiService.fetchProductByBarcode(barcode!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        if (!snapshot.hasData) {
          return const ProductNotFound();
        }

        final product = snapshot.data;
        if (product == null) {
          return const ErrorPage();
        }

        return FutureBuilder(
          future: Future.wait([
            _translateProductIngredients(product.ingredients),
            _translateProductAllergens(product.allergens),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }
            if (!snapshot.hasData) {
              return const ProductNotFound();
            }

            final result = snapshot.data;
            if (result == null) {
              return const ErrorPage();
            }

            Set<String> allergens = _extractAllergensFromIngredients(
              result[0],
              result[1],
            );

            Product translatedProduct = Product(
              barcode: product.barcode,
              productName: product.productName,
              brand: product.brand,
              images: product.images,
              ingredients: result[0],
              nutriments: product.nutriments,
              allergens: allergens,
              nutriscore: product.nutriscore,
              tags: product.tags,
            );

            // Add Product to Local Database
            try {
              ProductDatabaseService(product.barcode)
                  .addProduct(translatedProduct);
            } catch (e) {
              return const ErrorPage();
            }

            return ProductPage(translatedProduct);
          },
        );
      },
    );
  }

  Future<String> _translateProductIngredients(String ingredients) async {
    final translationResult =
        await DeepLTranslatorService.translate(ingredients);
    if (!translationResult.detectedSourceLang.compareIgnoreCase("PL")) {
      return translationResult.text;
    } else {
      return ingredients;
    }
  }

  Future<String> _translateProductAllergens(String allergens) async {
    final translationResult = await DeepLTranslatorService.translate(allergens);
    if (!translationResult.detectedSourceLang.compareIgnoreCase("PL")) {
      return translationResult.text;
    } else {
      return allergens;
    }
  }

  Set<String> _extractAllergensFromIngredients(
    String ingredients,
    String allergens,
  ) {
    var separatedAllergens = allergens.split(", ").map((e) => e.trim()).toSet();
    final extractedFromIngredients = separateWords(ingredients);
    separatedAllergens.addAll(extractedFromIngredients);

    Set<String> result = {};
    for (String allergen in separatedAllergens) {
      for (String key in allergensKeywordsFile.keys) {
        List<dynamic> keywords = allergensKeywordsFile[key]["keywords"];
        for (String keyword in keywords) {
          if (RegExp("^$keyword").hasMatch(allergen)) {
            result.add(key);
          }
        }
      }
    }
    return result;
  }
}
