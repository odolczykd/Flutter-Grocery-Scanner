import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/screens/product_page/shared/full_screen_image.dart';
import 'package:grocery_scanner/screens/product_page/shared/product_nutriscore_dialog_content.dart';
import 'package:grocery_scanner/services/auth.dart';
import 'package:grocery_scanner/services/user_database.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/label_row.dart';

const nutriscoreGrades = {"A", "B", "C", "D", "E"};

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage(this.product, {super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    String productImageUrl = widget.product.images.front;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (_) => FullScreenImage(productImageUrl));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(productImageUrl))),
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
                            _renderEditButton()
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _renderPinButton(),
                          _renderNutriscoreButton()
                        ],
                      ),
                    ],
                  )),
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
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),

                    // Brand
                    Text(
                      widget.product.brand,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),

                    // Proper Checker
                    _determineIfProductIsProper(),

                    // Ingredients
                    const SizedBox(height: 20),
                    LabelRow(
                      icon: Icons.list_alt,
                      labelText: "Skład produktu",
                      color: green,
                      isSecondaryIconEnabled: true,
                      secondaryIcon: Icons.image_outlined,
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => FullScreenImage(
                                widget.product.images.ingredients));
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
                      isSecondaryIconEnabled: true,
                      secondaryIcon: Icons.photo_outlined,
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => FullScreenImage(
                                widget.product.images.nutrition));
                      },
                    ),
                    const SizedBox(height: 5),
                    widget.product.nutriments.renderTable(),
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
          Navigator.pushNamed(context, "/home");
        },
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero, alignment: Alignment.topLeft),
        child: Container(
            decoration: const BoxDecoration(
                color: blackOpacity,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.arrow_back,
                size: 30,
                color: white,
              ),
            )),
      );

  Widget _renderEditButton() {
    return FutureBuilder(
      future: UserDatabaseService(_auth.currentUserUid!)
          .checkIfProductBelongsToUser(widget.product),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(width: 0);
        } else {
          return TextButton(
            onPressed: () {
              // TODO: Redirect to ProductCreator page with given barcode (edit mode)
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero, alignment: Alignment.topRight),
            child: Container(
                decoration: const BoxDecoration(
                    color: blackOpacity,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: const Padding(
                  padding: EdgeInsets.all(7),
                  child: Icon(
                    Icons.edit,
                    size: 25,
                    color: white,
                  ),
                )),
          );
        }
      },
    );
  }

  Widget _renderPinButton() {
    return FutureBuilder(
        future: UserDatabaseService(_auth.currentUserUid!)
            .checkIfProductIsPinned(widget.product),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(width: 0);
          } else {
            bool isProductAlreadyPinned = snapshot.data!;

            return TextButton(
              onPressed: () async {
                if (isProductAlreadyPinned) {
                  var result = await UserDatabaseService(_auth.currentUserUid!)
                      .pinProduct(widget.product, "unpin");
                  if (result != null) {
                    setState(() => isProductAlreadyPinned = false);
                    Fluttertoast.showToast(
                        msg: "Odpięto produkt",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Nie udało się odpiąć produktu",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16);
                  }
                } else {
                  var result = await UserDatabaseService(_auth.currentUserUid!)
                      .pinProduct(widget.product);
                  if (result != null) {
                    setState(() => isProductAlreadyPinned = true);
                    Fluttertoast.showToast(
                        msg: "Przypięto produkt",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Nie udało się przypiąć produktu",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16);
                  }
                }
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, alignment: Alignment.bottomLeft),
              child: Container(
                decoration: const BoxDecoration(
                    color: blackOpacity,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        isProductAlreadyPinned ? Icons.delete : Icons.push_pin,
                        color: white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isProductAlreadyPinned ? "Odepnij" : "Przypnij",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: white),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget _renderNutriscoreButton() {
    if (nutriscoreGrades.contains(widget.product.nutriscore.toUpperCase())) {
      return TextButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Wskaźnik Nutri-Score",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  content: const ProductNutriscoreDialogContent(),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(foregroundColor: black),
                      child: const Text("OK"),
                    )
                  ],
                )),
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero, alignment: Alignment.bottomRight),
        child: Container(
          decoration: BoxDecoration(
              color: nutriscoreColor(widget.product.nutriscore),
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              " ${widget.product.nutriscore.toUpperCase()} ",
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: white),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(width: 0);
    }
  }

  Widget _displayAllergens() {
    Map<String, String> allergenLabels = {
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

    if (widget.product.allergens.isEmpty) {
      return const Text(
        "Produkt nie zawiera alergenów.",
        style: TextStyle(fontStyle: FontStyle.italic),
      );
    }

    return Column(
      children: widget.product.allergens
          .map((e) => Row(
                children: [
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.navigate_next,
                    color: green,
                  ),
                  Text(allergenLabels[e]!)
                ],
              ))
          .toList(),
    );
  }

  Widget _determineIfProductIsProper() {
    // TODO: Implement this functionality
    bool isProper = false;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      decoration: isProper
          ? const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)), color: green)
          : const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)), color: red),
      child: Row(
        children: [
          (isProper
              ? const Icon(Icons.check_circle_outlined, color: white)
              : const Icon(
                  Icons.cancel_outlined,
                  color: white,
                )),
          const SizedBox(
            width: 5,
          ),
          (isProper
              ? const Text(
                  "Produkt jest dla Ciebie odpowiedni",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: white),
                )
              : const Text("Ten produkt nie jest dla Ciebie!",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: white)))
        ],
      ),
    );
  }
}
