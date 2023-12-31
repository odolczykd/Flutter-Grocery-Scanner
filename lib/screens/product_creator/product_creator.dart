// ignore_for_file: unnecessary_cast

import 'dart:io';

import 'package:barcode_finder/barcode_finder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/product_images.dart';
import 'package:grocery_scanner/models/product_nutriments.dart';
import 'package:grocery_scanner/screens/product_creator/input_dialogs/product_creator_barcode_input_dialog.dart';
import 'package:grocery_scanner/screens/product_creator/input_dialogs/product_creator_ingredients_input_dialog.dart';
import 'package:grocery_scanner/screens/product_creator/product_creator_tile.dart';
import 'package:grocery_scanner/screens/product_page/dialog_contents/product_nutriscore_dialog_content.dart';
import 'package:grocery_scanner/services/auth_service.dart';
import 'package:grocery_scanner/services/product_database_service.dart';
import 'package:grocery_scanner/services/user_database_service.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';
import 'package:grocery_scanner/shared/label_row.dart';
import 'package:image_picker/image_picker.dart';
import '../product_page/shared/allergens_functions.dart';
import '../product_page/dialog_contents/product_allergens_dialog_content.dart';
import 'allergens_list.dart';

const _nutriscoreGrades = {"A", "B", "C", "D", "E", "?"};
Map<String, dynamic> _emptyNutriment() => {"value": "N/A", "value_100g": "N/A"};

class ProductCreator extends StatefulWidget {
  final String? productBarcode;
  const ProductCreator({super.key, this.productBarcode});

  @override
  State<ProductCreator> createState() => _ProductCreatorState();
}

class _ProductCreatorState extends State<ProductCreator> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _firebaseStorage = FirebaseStorage.instance;
  final _imagePicker = ImagePicker();

  bool isProductAlreadySent = false;
  Set<String> formErrorMessages = {};

  File? productImageBarcode;
  File? productImageFront;
  File? productImageIngredients;
  File? productImageNutriments;

  // Form Field Values
  String productName = "";
  String brand = "";
  String barcode = "";
  String ingredients = "";
  Set<dynamic> allergens = {};
  ProductNutriments nutriments = ProductNutriments(
      energyKJ: _emptyNutriment(),
      energyKcal: _emptyNutriment(),
      fat: _emptyNutriment(),
      saturatedFat: _emptyNutriment(),
      carbohydrates: _emptyNutriment(),
      sugars: _emptyNutriment(),
      proteins: _emptyNutriment(),
      salt: _emptyNutriment());
  String nutriscore = "?";
  List<Map<String, String>> tags = [
    {"name": "palm_oil_free", "status": "unknown"},
    {"name": "vegetarian", "status": "unknown"},
    {"name": "vegan", "status": "unknown"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dodaj nowy produkt",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Product Name
                    FormTextField(
                        labelText: "Nazwa produktu",
                        color: green,
                        obscureText: false,
                        callback: (val) {
                          setState(() => productName = val);
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Nazwa produktu nie może być pusta";
                          } else if (val.length > 50) {
                            return "Nazwa produktu jest za długa";
                          } else {
                            return null;
                          }
                        }),

                    // Brand
                    const SizedBox(height: 10),
                    FormTextField(
                        labelText: "Marka",
                        color: green,
                        obscureText: false,
                        callback: (val) {
                          setState(() => brand = val);
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Marka nie może być pusta";
                          } else {
                            return null;
                          }
                        }),

                    // Image Tiles
                    const SizedBox(height: 10),
                    _renderTiles(),

                    const SizedBox(height: 10),
                    const Text(
                        "Uzupełnij pozostałe dane i popraw te, które zostały niedokładnie odczytane z dodanych zdjęć",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),

                    // Barcode
                    LabelRow(
                        icon: Icons.qr_code_scanner,
                        labelText: "Kod kreskowy",
                        color: green,
                        isSecondaryIconEnabled: true,
                        secondaryIcon: Icons.edit,
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) =>
                                ProductCreatorBarcodeInputDialog(
                                    initValue: barcode,
                                    setValue: (input) =>
                                        setState(() => barcode = input)))),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: barcode.isNotEmpty
                            ? Text(barcode,
                                style: const TextStyle(fontSize: 16))
                            : const Text(
                                "Nie zeskanowano kodu kreskowego",
                                style: TextStyle(fontStyle: FontStyle.italic),
                                textAlign: TextAlign.left,
                              )),

                    // Ingredients
                    const SizedBox(height: 10.0),
                    LabelRow(
                      icon: Icons.format_list_bulleted,
                      labelText: "Skład produktu",
                      color: green,
                      isSecondaryIconEnabled: true,
                      secondaryIcon: Icons.edit,
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) =>
                              ProductCreatorIngredientsInputDialog(
                                  initValue: ingredients,
                                  setValue: (input) async {
                                    setState(() => ingredients = input);
                                    await _extractAllergensFromIngredients(
                                        input);
                                  })),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: ingredients.isNotEmpty
                            ? Text(ingredients)
                            : const Text(
                                "Nie dodano składu produktu",
                                style: TextStyle(fontStyle: FontStyle.italic),
                                textAlign: TextAlign.left,
                              )),

                    // Allergens
                    const SizedBox(height: 10),
                    LabelRow(
                        icon: Icons.egg_outlined,
                        labelText: "Lista alergenów",
                        color: green,
                        isSecondaryIconEnabled: true,
                        secondaryIcon: Icons.info_outline,
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text(
                                      "Jak szukać alergenów na etykiecie produktu?",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  content:
                                      const ProductAllergensDialogContent(),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: TextButton.styleFrom(
                                          foregroundColor: black),
                                      child: const Text("OK"),
                                    )
                                  ],
                                ))),
                    ProductCreatorAllergensList(
                        allergens: allergens,
                        callback: (updatedAllergens) {
                          setState(() => allergens = updatedAllergens);
                        }),

                    // Nutriments
                    const SizedBox(height: 10),
                    const LabelRow(
                        icon: Icons.fastfood_outlined,
                        labelText: "Tabela wartości odżywczych",
                        color: green,
                        isSecondaryIconEnabled: false),
                    const Text(
                        "Jeśli któraś z wartości nie jest podana, pozostaw puste pole",
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    const SizedBox(height: 10),
                    _renderNutritionTable(),

                    // Nutri-Score
                    const SizedBox(height: 10),
                    LabelRow(
                        icon: Icons.local_pizza_outlined,
                        labelText: "Nutri-Score",
                        color: green,
                        isSecondaryIconEnabled: true,
                        secondaryIcon: Icons.info_outline,
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Wskaźnik Nutri-Score",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  content:
                                      const ProductNutriscoreDialogContent(),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: TextButton.styleFrom(
                                          foregroundColor: black),
                                      child: const Text("OK"),
                                    )
                                  ],
                                ))),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _nutriscoreGrades
                          .map((e) => GestureDetector(
                              onTap: () => setState(() => nutriscore = e),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    nutriscoreTile(e),
                                    if (nutriscore == e)
                                      const Icon(
                                        Icons.keyboard_arrow_up,
                                        size: 30,
                                      )
                                  ])))
                          .toList(),
                    ),

                    // Additional Info (Tags)
                    const SizedBox(height: 10),
                    const LabelRow(
                        icon: Icons.eco_outlined,
                        labelText: "Dodatkowe informacje",
                        color: green,
                        isSecondaryIconEnabled: false),
                    _renderAdditionalInfoCheckboxes(),

                    const SizedBox(height: 10),
                    _renderFormErrors(),

                    // Home Button
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("/home");
                            },
                            style: ButtonStyle(
                                elevation: const MaterialStatePropertyAll(0),
                                backgroundColor:
                                    const MaterialStatePropertyAll(green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.home_outlined),
                                SizedBox(width: 5),
                                Text("WRÓĆ NA STRONĘ GŁÓWNĄ",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            )),

                        // Add Product Button
                        const SizedBox(width: 10),
                        FilledButton(
                            onPressed: () async {
                              // Check if product already exists
                              final productChecker =
                                  await ProductDatabaseService(barcode)
                                      .getProduct();
                              if (productChecker != null) {
                                setState(() {
                                  isProductAlreadySent = true;
                                });
                                Fluttertoast.showToast(
                                    msg: "Ten produkt już został dodany",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 16);
                                return;
                              }

                              if (isProductAlreadySent) {
                                return;
                              }

                              setState(() {
                                formErrorMessages.clear();
                              });

                              String imageFrontUrl = "";
                              String imageIngredientsUrl = "";
                              String imageNutrimentsUrl = "";

                              if (productImageFront == null) {
                                setState(() {
                                  formErrorMessages
                                      .add("Dodaj zdjęcie przodu produktu");
                                });
                              } else {
                                imageFrontUrl =
                                    await _uploadImageToFirebaseStorage(
                                        image: productImageFront!,
                                        type: "front",
                                        barcode: barcode);
                              }

                              if (productImageIngredients == null) {
                                setState(() {
                                  formErrorMessages
                                      .add("Dodaj zdjęcie składu produktu");
                                });
                              } else {
                                imageIngredientsUrl =
                                    await _uploadImageToFirebaseStorage(
                                        image: productImageIngredients!,
                                        type: "ingredients",
                                        barcode: barcode);
                              }

                              if (productImageNutriments == null) {
                                setState(() {
                                  formErrorMessages
                                      .add("Dodaj zdjęcie wartości odżywczych");
                                });
                              } else {
                                imageNutrimentsUrl =
                                    await _uploadImageToFirebaseStorage(
                                        image: productImageNutriments!,
                                        type: "nutriments",
                                        barcode: barcode);
                              }

                              if (_formKey.currentState!.validate() &&
                                  formErrorMessages.isEmpty) {
                                final product = Product(
                                    barcode: barcode,
                                    productName: productName,
                                    brand: brand,
                                    images: ProductImages(
                                        front: imageFrontUrl,
                                        ingredients: imageIngredientsUrl,
                                        nutrition: imageNutrimentsUrl),
                                    ingredients: ingredients,
                                    nutriments: nutriments,
                                    allergens: allergens,
                                    nutriscore: nutriscore == "?"
                                        ? "unknown"
                                        : nutriscore,
                                    tags: tags);

                                Fluttertoast.showToast(
                                    msg: "Trwa dodawanie produktu...",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 16);

                                // Add Product to Firestore
                                final response =
                                    await ProductDatabaseService(barcode)
                                        .addProduct(product);
                                if (response == false) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Nie udało się dodać nowego produktu",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      fontSize: 16);
                                } else {
                                  setState(() {
                                    isProductAlreadySent = true;
                                  });

                                  // Add Product to logged user's products list
                                  await UserDatabaseService(
                                          _auth.currentUserUid!)
                                      .relateUserWithProduct(barcode);

                                  Fluttertoast.showToast(
                                      msg: "Pomyślnie dodano nowy produkt",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      fontSize: 16);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Popraw wszystkie pola formularza",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 16);
                              }
                            },
                            style: ButtonStyle(
                                elevation: const MaterialStatePropertyAll(0),
                                backgroundColor: isProductAlreadySent
                                    ? const MaterialStatePropertyAll(
                                        greyButtonFullOpacity)
                                    : const MaterialStatePropertyAll(green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 5),
                                Text("DODAJ PRODUKT",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            )),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    )));
  }

  Future _getImageFromCamera({required String type}) async {
    final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);

    setState(() {
      if (pickedImage != null) {
        switch (type) {
          case "barcode":
            productImageBarcode = File(pickedImage.path);
            break;
          case "front":
            productImageFront = File(pickedImage.path);
            break;
          case "ingriedients":
            productImageIngredients = File(pickedImage.path);
            break;
          case "nutriments":
            productImageNutriments = File(pickedImage.path);
            break;
          default:
            break;
        }
      }
    });
  }

  Future _readTextFromImage({required String type}) async {
    final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);

    setState(() {
      if (pickedImage != null) {
        switch (type) {
          case "front":
            productImageFront = File(pickedImage.path);
            break;
          case "ingredients":
            productImageIngredients = File(pickedImage.path);
            break;
          case "nutriments":
            productImageNutriments = File(pickedImage.path);
            break;
          default:
            return;
        }
      }
    });

    if (pickedImage != null) {
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer
          .processImage(InputImage.fromFile(File(pickedImage.path)));

      setState(() {
        switch (type) {
          case "ingredients":
            ingredients = recognizedText.text.replaceAll("\n", " ");
            break;
          case "nutriments":
            break;
          default:
            break;
        }
      });

      textRecognizer.close();
    }
  }

  Future _extractAllergensFromIngredients(String ingredients) async {
    Set extractedAllergens = {};
    Set separatedCandidates = {};

    final json = await readJsonFile("assets/data/allergens.json");

    final extractedFromIngredients = separateWords(ingredients);
    separatedCandidates.addAll(extractedFromIngredients);

    for (String allergen in separatedCandidates) {
      for (String key in json.keys) {
        List<dynamic> keywords = json[key]["keywords"];
        for (String keyword in keywords) {
          if (RegExp("^$keyword").hasMatch(allergen)) {
            extractedAllergens.add(key);
          }
        }
      }
    }

    setState(() {
      allergens.addAll(extractedAllergens);
    });
  }

  Widget _renderTiles() {
    return Column(children: [
      Row(
        children: [
          // Barcode Scanner
          Expanded(
            flex: 1,
            child: ProductCreatorImageInputTile(
              icon: Icons.barcode_reader,
              text: "Zeskanuj kod kreskowy",
              position: TilePosition.left,
              onPressed: () async {
                await _getImageFromCamera(type: "barcode");
                if (productImageBarcode != null) {
                  String? scanResult;

                  try {
                    scanResult = await BarcodeFinder.scanFile(
                        path: productImageBarcode!.path,
                        formats: [BarcodeFormat.EAN_8, BarcodeFormat.EAN_13]);
                  } on Exception {
                    scanResult = null;
                  }

                  setState(() {
                    if (scanResult != null) {
                      barcode = scanResult;
                    }
                  });
                }
              },
            ),
          ),

          // Product Front Image
          Expanded(
            flex: 1,
            child: ProductCreatorImageInputTile(
                icon: Icons.lunch_dining,
                text: "Dodaj zdjęcie przodu produktu",
                position: TilePosition.right,
                onPressed: () async {
                  if (productImageFront != null) {
                    setState(() {
                      productImageFront = null;
                    });
                  } else {
                    await _getImageFromCamera(type: "front");
                  }
                },
                image: productImageFront,
                deleteText: "Usuń zdjęcie przodu produktu"),
          )
        ],
      ),
      Row(
        children: [
          // Product Ingredients Image
          Expanded(
            flex: 1,
            child: ProductCreatorImageInputTile(
                icon: Icons.format_list_bulleted,
                text: "Dodaj zdjęcie składu produktu",
                position: TilePosition.left,
                onPressed: () async {
                  if (productImageIngredients == null) {
                    await _readTextFromImage(type: "ingredients");
                    await _extractAllergensFromIngredients(ingredients);
                  } else {
                    setState(() {
                      productImageIngredients = null;
                    });
                  }
                },
                image: productImageIngredients,
                deleteText: "Usuń zdjęcie składu produktu"),
          ),

          // Product Nutriments Image
          Expanded(
              flex: 1,
              child: ProductCreatorImageInputTile(
                  icon: Icons.fastfood,
                  text: "Dodaj zdjęcie wart. odżywczych",
                  position: TilePosition.right,
                  onPressed: () async {
                    if (productImageNutriments == null) {
                      await _getImageFromCamera(type: "nutriments");
                    } else {
                      setState(() {
                        productImageNutriments = null;
                      });
                    }
                  },
                  image: productImageNutriments,
                  deleteText: "Usuń zdjęcie wart. odżywczych"))
        ],
      )
    ]);
  }

  Widget _renderNutritionTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2)
      },
      children: [
        // Header
        TableRow(children: [
          Container(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: const Align(
              alignment: Alignment.center,
              child: Text("w porcji",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: const Align(
              alignment: Alignment.center,
              child: Text("w 100 g/ml",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ]),

        // Energy [kJ]
        TableRow(children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "energia [kJ]",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              labelText: "",
              color: green,
              obscureText: false,
              callback: (val) => setState(() {
                nutriments.energyKJ["value"] = val!.isNotEmpty ? val : "N/A";
              }),
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              labelText: "",
              color: green,
              obscureText: false,
              callback: (val) => setState(() {
                nutriments.energyKJ["value_100g"] =
                    val!.isNotEmpty ? val : "N/A";
              }),
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          )
        ]),

        // Energy [kcal]
        TableRow(decoration: const BoxDecoration(color: greyBg), children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "energia [kcal]",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.energyKcal["value"] = val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.energyKcal["value_100g"] =
                    val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          )
        ]),

        // Fat
        TableRow(children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "tłuszcz",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.fat["value"] = val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.fat["value_100g"] = val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          )
        ]),

        // Saturated Fat
        TableRow(decoration: const BoxDecoration(color: greyBg), children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "kwasy nasycone",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.saturatedFat["value"] =
                    val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.saturatedFat["value_100g"] =
                    val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          )
        ]),

        // Carbohydrates
        TableRow(children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "węglowodany",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.carbohydrates["value"] =
                    val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.carbohydrates["value_100g"] =
                    val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          )
        ]),

        // Sugars
        TableRow(decoration: const BoxDecoration(color: greyBg), children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "cukry",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.sugars["value"] = val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.sugars["value_100g"] = val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          )
        ]),

        // Proteins
        TableRow(children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "białko",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.proteins["value"] = val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.proteins["value_100g"] =
                    val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          )
        ]),

        // Salt
        TableRow(decoration: const BoxDecoration(color: greyBg), children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "sól",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.salt["value"] = val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.salt["value_100g"] = val!.isNotEmpty ? val : "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {
                if (val!.isNotEmpty &&
                    !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                  return "Tylko liczby";
                } else {
                  return null;
                }
              },
            ),
          )
        ])
      ],
    );
  }

  Widget _renderAdditionalInfoCheckboxes() {
    return Table(
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
      children: [
        // Palm Oil
        TableRow(children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(
              "Czy produkt zawiera olej palmowy?",
              style: TextStyle(fontSize: 16),
            ),
          ),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: DropdownButton(
                  value: tags[0]["status"],
                  items: const [
                    DropdownMenuItem(value: "positive", child: Text("Tak")),
                    DropdownMenuItem(value: "negative", child: Text("Nie")),
                    DropdownMenuItem(value: "unknown", child: Text("Nie wiem"))
                  ],
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (val) {
                    setState(() => tags[0]["status"] = val ?? "unknown");
                    print(tags);
                  }))
        ]),

        // Vegetarian
        TableRow(children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(
              "Czy produkt jest wegetariański?",
              style: TextStyle(fontSize: 16),
            ),
          ),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: DropdownButton(
                  value: tags[1]["status"],
                  items: const [
                    DropdownMenuItem(value: "positive", child: Text("Tak")),
                    DropdownMenuItem(value: "negative", child: Text("Nie")),
                    DropdownMenuItem(
                        value: "maybe", child: Text("Może nie być")),
                    DropdownMenuItem(value: "unknown", child: Text("Nie wiem"))
                  ],
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (val) {
                    setState(() => tags[1]["status"] = val ?? "unknown");
                    print(tags);
                  }))
        ]),

        // Vegan
        TableRow(children: [
          const TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(
              "Czy produkt jest wegański?",
              style: TextStyle(fontSize: 16),
            ),
          ),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: DropdownButton(
                  value: tags[2]["status"],
                  items: const [
                    DropdownMenuItem(value: "positive", child: Text("Tak")),
                    DropdownMenuItem(value: "negative", child: Text("Nie")),
                    DropdownMenuItem(
                        value: "maybe", child: Text("Może nie być")),
                    DropdownMenuItem(value: "unknown", child: Text("Nie wiem"))
                  ],
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (val) {
                    setState(() => tags[2]["status"] = val ?? "unknown");
                    print(tags);
                  }))
        ])
      ],
    );
  }

  Widget _renderFormErrors() {
    return Column(
        children: formErrorMessages
            .map((e) =>
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.error_outline, color: red),
                  const SizedBox(width: 5),
                  Text(e, style: const TextStyle(color: red))
                ]))
            .toList());
  }

  Future _uploadImageToFirebaseStorage(
      {required File image,
      required String type,
      required String barcode}) async {
    final fileName = "$barcode-$type.jpg";
    final destination = "products/$fileName";

    try {
      final ref = _firebaseStorage.ref(destination);
      await ref.putFile(image);
      return "https://firebasestorage.googleapis.com/v0/b/wmii-umk-grocery-scanner.appspot.com/o/products%2F$fileName?alt=media";
    } on Exception {
      setState(() {
        formErrorMessages.add("Nie udało się zapisać wprowadzonych zdjęć");
      });
      return "";
    }
  }
}
