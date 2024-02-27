import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/screens/product_page/product_page.dart';
import 'package:grocery_scanner/screens/product_page/product_not_found.dart';
import 'package:grocery_scanner/screens/product_page/shared/allergens_functions.dart';
import 'package:grocery_scanner/services/open_food_facts_service.dart';
import 'package:grocery_scanner/services/product_database_service.dart';
import 'package:grocery_scanner/services/deepl_translator_service.dart';
import 'package:grocery_scanner/shared/error_page.dart';
import 'package:grocery_scanner/shared/loading.dart';

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
      try {
        productFuture =
            OpenFoodFactsApiService.fetchProductByBarcode(widget.barcode!);
        productFuture.then((product) async {
          // Translate Product Ingredients
          final ingredientsTranslation =
              await DeepLTranslatorService.translate(product!.ingredients);
          setState(() {
            productIngredientsTranslation = !ingredientsTranslation
                    .detectedSourceLang
                    .compareIgnoreCase("PL")
                ? ingredientsTranslation.text
                : product.ingredients;
          });

          // Translate Product Allergens
          final allergensTranslation =
              await DeepLTranslatorService.translate(product.allergens);
          setState(() {
            productAllergensTranslation =
                !allergensTranslation.detectedSourceLang.compareIgnoreCase("PL")
                    ? allergensTranslation.text
                    : product.allergens;
          });

          // Extract Allergens from Ingredients
          final json = await readJsonFile("assets/data/allergens.json");
          var separatedAllergens = productAllergensTranslation!
              .split(", ")
              .map((e) => e.trim())
              .toSet();
          final extractedFromIngredients =
              separateWords(productIngredientsTranslation);
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
      } catch (e) {
        productFuture = Future.value(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: productFuture,
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

        Product translatedProduct = Product(
          barcode: product.barcode,
          productName: product.productName,
          brand: product.brand,
          images: product.images,
          ingredients: productIngredientsTranslation ?? "",
          nutriments: product.nutriments,
          allergens: allergens,
          nutriscore: product.nutriscore,
          tags: product.tags,
        );

        // Add Product to Local Database
        try {
          ProductDatabaseService(product.barcode).addProduct(translatedProduct);
        } catch (e) {
          return const ErrorPage();
        }

        return ProductPage(translatedProduct);
      },
    );
  }
}
