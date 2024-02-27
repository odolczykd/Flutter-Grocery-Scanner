import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/offline_mode/full_screen_image_offline.dart';
import 'package:grocery_scanner/screens/product_page/dialog_contents/product_nutriscore_dialog_content.dart';
import 'package:grocery_scanner/screens/product_page/shared/product_tags.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/label_row.dart';

const nutriscoreGrades = {"A", "B", "C", "D", "E"};

class OfflineProductPage extends StatefulWidget {
  final UserData? user;
  final ProductOffline product;
  const OfflineProductPage({
    super.key,
    required this.user,
    required this.product,
  });

  @override
  State<OfflineProductPage> createState() => _OfflineProductPageState();
}

class _OfflineProductPageState extends State<OfflineProductPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<int>? productImageBytes = widget.product.images.front;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Front Image + Buttons
            GestureDetector(
              onTap: () async {
                if (productImageBytes != null) {
                  await showDialog(
                    context: context,
                    builder: (_) => FullScreenImageOffline(productImageBytes),
                  );
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: productImageBytes != null
                        ? MemoryImage(Uint8List.fromList(productImageBytes))
                        : const AssetImage("assets/img/no_image.png")
                            as ImageProvider,
                  ),
                ),
                child: OverflowBox(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: 300,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _renderReturnButton(),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: 0),
                            _renderNutriscoreButton()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    const SizedBox(height: 25),
                    Text(
                      widget.product.productName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Brand
                    Text(
                      widget.product.brand,
                      style: const TextStyle(fontSize: 18),
                    ),

                    // Proper Checker
                    if (widget.user != null) const SizedBox(height: 20),
                    if (widget.user != null) _determineIfProductIsProper(),

                    // Ingredients
                    const SizedBox(height: 20),
                    LabelRow(
                      icon: Icons.list_alt,
                      labelText: "Skład produktu",
                      color: green,
                      isSecondaryIconEnabled:
                          widget.product.images.ingredients != null,
                      secondaryIcon: Icons.image_outlined,
                      onTap: () async {
                        if (widget.product.images.ingredients != null) {
                          await showDialog(
                            context: context,
                            builder: (_) => FullScreenImageOffline(
                              widget.product.images.ingredients!,
                            ),
                          );
                        }
                      },
                    ),
                    Text(widget.product.ingredients),

                    // Allergens
                    const SizedBox(height: 15),
                    const LabelRow(
                      icon: Icons.egg_outlined,
                      labelText: "Alergeny",
                      color: green,
                      isSecondaryIconEnabled: false,
                    ),
                    _displayAllergens(),

                    // Nutriments
                    const SizedBox(height: 15),
                    LabelRow(
                      icon: Icons.fastfood_outlined,
                      labelText: "Wartości odżywcze",
                      color: green,
                      isSecondaryIconEnabled:
                          widget.product.images.nutrition != null,
                      secondaryIcon: Icons.photo_outlined,
                      onTap: () async {
                        if (widget.product.images.nutrition != null) {
                          await showDialog(
                            context: context,
                            builder: (_) => FullScreenImageOffline(
                              widget.product.images.nutrition!,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    widget.product.nutriments.renderTable(),

                    // Tags
                    const SizedBox(height: 20),
                    const LabelRow(
                      icon: Icons.eco_outlined,
                      labelText: "Dodatkowe informacje",
                      color: green,
                      isSecondaryIconEnabled: false,
                    ),
                    const SizedBox(height: 5),
                    ProductTags(tags: widget.product.tags),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderReturnButton() => TextButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, "/");
        },
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero, alignment: Alignment.topLeft),
        child: Container(
          decoration: const BoxDecoration(
            color: blackOpacity,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: white,
            ),
          ),
        ),
      );

  Widget _renderNutriscoreButton() {
    if (!nutriscoreGrades.contains(widget.product.nutriscore.toUpperCase())) {
      // Do not display button
      return const SizedBox(width: 0);
    } else {
      return TextButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Wskaźnik Nutri-Score",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const ProductNutriscoreDialogContent(),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: black),
                child: const Text("OK"),
              )
            ],
          ),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          alignment: Alignment.bottomRight,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: nutriscoreColor(widget.product.nutriscore),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              " ${widget.product.nutriscore.toUpperCase()} ",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _displayAllergens() {
    if (widget.product.allergens.isEmpty) {
      return const Text(
        "Produkt nie zawiera alergenów.",
        style: TextStyle(fontStyle: FontStyle.italic),
      );
    }

    return Column(
      children: widget.product.allergens
          .map(
            (e) => Row(
              children: [
                const SizedBox(width: 5),
                const Icon(Icons.navigate_next, color: green),
                Flexible(
                  child: Text(
                    _allergenLabels[e]!,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _determineIfProductIsProper() {
    bool isProper = true;
    Set<String> detectedPreferences = {};
    Set<String> detectedRestrictions = {};

    Map<String, String> preferencesTranslator = {
      "palm_oil_free": "produkt zawiera olej palmowy",
      "vegetarian": "produkt nie jest lub może nie być wegetariański",
      "vegan": "produkt nie jest lub może nie być wegański"
    };

    final userRestrictions = widget.user!.restrictions;
    final userPreferences = widget.user!.preferences;

    // Restrictions
    for (String restr in userRestrictions) {
      if (widget.product.allergens.contains(restr)) {
        isProper = false;
        detectedRestrictions.add(_allergenLabels[restr]!);
      }
    }

    // Preferences
    for (String pref in userPreferences) {
      Map<dynamic, dynamic> productTag =
          widget.product.tags.firstWhere((element) => element["name"] == pref);

      if (pref == "palm_oil_free") {
        if (productTag["status"] == "negative") {
          isProper = false;
          detectedPreferences.add(preferencesTranslator[pref]!);
        }
      } else if (pref == "vegetarian") {
        if (productTag["status"] == "negative" ||
            productTag["status"] == "maybe") {
          isProper = false;
          detectedPreferences.add(preferencesTranslator[pref]!);
        }
      } else if (pref == "vegan") {
        if (productTag["status"] == "negative" ||
            productTag["status"] == "maybe") {
          isProper = false;
          detectedPreferences.add(preferencesTranslator[pref]!);
        }
      } else {}
    }

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(5),
          decoration: isProper
              ? const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: green,
                )
              : const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: red,
                ),
          child: Row(
            children: [
              isProper
                  ? const Icon(Icons.check_circle_outlined, color: white)
                  : const Icon(
                      Icons.cancel_outlined,
                      color: white,
                    ),
              const SizedBox(width: 5),
              isProper
                  ? const Text(
                      "Produkt jest dla Ciebie odpowiedni",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    )
                  : const Text(
                      "Ten produkt nie jest dla Ciebie!",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    )
            ],
          ),
        ),
        if (isProper == false && detectedRestrictions.isNotEmpty)
          const SizedBox(height: 10),
        if (isProper == false && detectedRestrictions.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Produkt zawiera wskazane przez Ciebie ograniczenia:",
                style: TextStyle(fontWeight: FontWeight.bold, color: red),
              ),
              const SizedBox(height: 5),
              Column(
                children: detectedRestrictions
                    .map(
                      (restr) => Row(
                        children: [
                          const Icon(
                            Icons.navigate_next,
                            color: red,
                          ),
                          Expanded(
                              child: Text(
                            restr,
                            style: const TextStyle(color: red),
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        if (isProper == false && detectedPreferences.isNotEmpty)
          const SizedBox(height: 10),
        if (isProper == false && detectedPreferences.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Produkt nie spełnia wskazanych przez Ciebie wymagań:",
                style: TextStyle(fontWeight: FontWeight.bold, color: red),
              ),
              const SizedBox(height: 5),
              Column(
                children: detectedPreferences
                    .map(
                      (restr) => Row(
                        children: [
                          const Icon(
                            Icons.navigate_next,
                            color: red,
                          ),
                          Expanded(
                            child: Text(
                              restr,
                              style: const TextStyle(color: red),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
      ],
    );
  }
}

Map<String, String> _allergenLabels = {
  "gluten": "zboża zawierające gluten i produkty pochodne",
  "shellfish": "skorupiaki i produkty pochodne",
  "eggs": "jaja i produkty pochodne",
  "fish": "ryby i produkty pochodne",
  "peanuts": "orzeszki ziemne (arachidowe) i produkty pochodne",
  "soya": "soja i produkty pochodne",
  "milk": "mleko i produkty pochodne, laktoza",
  "nuts": "orzechy i produkty pochodne",
  "celery": "seler i produkty pochodne",
  "mustard": "gorczyca i produkty pochodne",
  "sesame_seeds": "nasiona sezamu i produkty pochodne",
  "sulphur_dioxide": "dwutlenek siarki, siarczyny i produkty pochodne",
  "lupin": "łubin i produkty pochodne",
  "molluscs": "mięczaki i produkty pochodne"
};
