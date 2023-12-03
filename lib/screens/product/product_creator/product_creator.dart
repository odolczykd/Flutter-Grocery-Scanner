// ignore_for_file: unnecessary_cast

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/product_nutriments.dart';
import 'package:grocery_scanner/screens/product/product_creator/product_creator_tile.dart';
import 'package:grocery_scanner/services/auth.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';
import 'package:grocery_scanner/shared/label_row.dart';
import 'package:image_picker/image_picker.dart';
import '../shared/allergens_functions.dart';
import '../shared/product_allergens_dialog_content.dart';
import 'allergens_list.dart';

const _nutriscoreGrades = {"A", "B", "C", "D", "E", "?"};
Map<String, dynamic> _emptyNutriment = {"value": "N/A", "value_100g": "N/A"};

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

  File? productImageBarcode;
  File? productImageFront;
  File? productImageIngredients;
  File? productImageNutriments;

  // Form Field Values
  String productName = "";
  String brand = "";
  String country = "";
  String barcode = "";
  String ingredients = "";
  Set<dynamic> allergens = {};
  ProductNutriments nutriments = ProductNutriments(
      energyKJ: _emptyNutriment,
      energyKcal: _emptyNutriment,
      fat: _emptyNutriment,
      saturatedFat: _emptyNutriment,
      carbohydrates: _emptyNutriment,
      sugars: _emptyNutriment,
      proteins: _emptyNutriment,
      salt: _emptyNutriment);
  String nutriscore = "?";

  Widget _renderTiles() => Column(children: [
        Row(
          children: [
            // Barcode Scanner
            Expanded(
              flex: 1,
              child: ProductCreatorTile(
                icon: Icons.qr_code_scanner,
                text: "Zeskanuj kod kreskowy",
                position: TilePosition.left,
                onPressed: () async {
                  await _getImageFromCamera(type: "barcode");
                  if (productImageBarcode != null) {
                    final inputImage =
                        InputImage.fromFile(productImageBarcode!);
                    final barcodeScanner = BarcodeScanner(
                        formats: [BarcodeFormat.ean8, BarcodeFormat.ean13]);
                    final barcodes =
                        await barcodeScanner.processImage(inputImage);

                    setState(() {
                      barcode = barcodes[0].rawValue!;
                    });
                  }
                },
              ),
            ),

            // Product Front Image
            Expanded(
              flex: 1,
              child: ProductCreatorTile(
                icon: Icons.lunch_dining,
                text: "Dodaj zdjęcie przodu produktu",
                position: TilePosition.right,
                onPressed: () async {
                  await _getImageFromCamera(type: "front");
                  await _uploadImageToFirebaseStorage(
                      image: productImageFront!,
                      type: "front",
                      barcode: "12345");
                },
                image: productImageFront,
                deleteText: "Usuń zdjęcie przodu produktu",
                onDelete: () {},
              ),
            )
          ],
        ),
        Row(
          children: [
            // Product Ingredients Image
            Expanded(
              flex: 1,
              child: ProductCreatorTile(
                icon: Icons.format_list_bulleted,
                text: "Dodaj zdjęcie składu produktu",
                position: TilePosition.left,
                onPressed: () async {
                  await _readTextFromImage(type: "ingredients");
                  await _extractAllergensFromIngredients(ingredients);
                },
                image: productImageIngredients,
                deleteText: "Usuń zdjęcie składu produktu",
                onDelete: () {},
              ),
            ),

            // Product Nutriments Image
            Expanded(
                flex: 1,
                child: ProductCreatorTile(
                  icon: Icons.fastfood,
                  text: "Dodaj zdjęcie wart. odżywczych",
                  position: TilePosition.right,
                  onPressed: () async {
                    await _getImageFromCamera(type: "nutriments");
                  },
                  image: productImageNutriments,
                  deleteText: "Usuń zdjęcie wart. odżywczych",
                  onDelete: () {},
                ))
          ],
        )
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dodaj nowy produkt",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    FormTextField(
                        labelText: "Nazwa produktu",
                        color: green,
                        obscureText: false,
                        validator: (val) {}),
                    const SizedBox(height: 10.0),
                    FormTextField(
                        labelText: "Marka",
                        color: green,
                        obscureText: false,
                        validator: (val) {}),
                    const SizedBox(height: 10.0),
                    FormTextField(
                        labelText: "Kraj pochodzenia",
                        color: green,
                        obscureText: false,
                        validator: (val) {}),
                    const SizedBox(height: 10),
                    _renderTiles(),
                    const SizedBox(height: 10),
                    const Text(
                        "Uzupełnij pozostałe dane i popraw te, które zostały niedokładnie odczytane z dodanych zdjęć",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10.0),
                    FormTextField(
                      labelText: "Kod kreskowy",
                      color: green,
                      obscureText: false,
                      validator: (val) {},
                      value: barcode,
                    ),
                    const SizedBox(height: 10.0),
                    FormTextField(
                      labelText: "Skład produktu",
                      color: green,
                      obscureText: false,
                      validator: (val) {},
                      value: ingredients,
                      multiline: true,
                    ),
                    const SizedBox(height: 10.0),
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
                                          fontSize: 20.0,
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
                    ProductCreatorAllergensList(allergens),
                    const SizedBox(height: 10.0),
                    LabelRow(
                        icon: Icons.fastfood_outlined,
                        labelText: "Tabela wartości odżywczych",
                        color: green,
                        isSecondaryIconEnabled: true,
                        secondaryIcon: Icons.info_outline,
                        onTap: () {}),
                    _renderNutritionTable(),
                    const SizedBox(height: 10.0),
                    const LabelRow(
                        icon: Icons.local_pizza_outlined,
                        labelText: "Nutri-Score",
                        color: green,
                        isSecondaryIconEnabled: false),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _nutriscoreGrades
                          .map((e) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  nutriscore = e;
                                });
                              },
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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                            onPressed: () {
                              _formKey.currentState?.reset();
                            },
                            style: ButtonStyle(
                                elevation: const MaterialStatePropertyAll(0.0),
                                backgroundColor:
                                    const MaterialStatePropertyAll(green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)))),
                            child: const Row(
                              children: [
                                Icon(Icons.delete_outline),
                                SizedBox(width: 5),
                                Text("WYCZYŚĆ", style: TextStyle(fontSize: 16)),
                              ],
                            )),
                        const SizedBox(width: 10),
                        FilledButton(
                            onPressed: () async {
                              // final product = Product(
                              //     barcode: barcode,
                              //     productName: productName,
                              //     brand: brand,
                              //     country: country,
                              //     images: images,
                              //     ingredients: ingredients,
                              //     nutriments: nutriments,
                              //     allergens: allergens,
                              //     nutriscore: nutriscore);
                            },
                            style: ButtonStyle(
                                elevation: const MaterialStatePropertyAll(0.0),
                                backgroundColor:
                                    const MaterialStatePropertyAll(green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)))),
                            child: const Row(
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
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.camera);

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
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.camera);

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
      allergens = extractedAllergens;
    });
  }

  Widget _renderNutritionTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1)
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
              callback: (val) => setState(() {
                nutriments.energyKJ["value"] = val ?? "N/A";
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
                nutriments.energyKJ["value_100g"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
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
                nutriments.energyKcal["value"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.energyKcal["value_100g"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
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
                nutriments.fat["value"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.fat["value_100g"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
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
                "\t\tw tym kwasy nasycone",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.saturatedFat["value"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.saturatedFat["value_100g"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
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
                nutriments.carbohydrates["value"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.carbohydrates["value_100g"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
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
                "\t\tw tym cukry",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.sugars["value"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.sugars["value_100g"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
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
                nutriments.proteins["value"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.proteins["value_100g"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
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
                nutriments.salt["value"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: FormTextField(
              callback: (val) => setState(() {
                nutriments.salt["value_100g"] = val ?? "N/A";
              }),
              labelText: "",
              color: green,
              obscureText: false,
              validator: (val) {},
            ),
          )
        ])
      ],
    );
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
    } on Exception {
      print("Nie udalo sie dodac zdjecia");
    }
  }
}
