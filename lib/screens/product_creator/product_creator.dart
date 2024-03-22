// ignore_for_file: unnecessary_cast, use_build_context_synchronously

import 'dart:io';

import 'package:barcode_finder/barcode_finder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/product_images.dart';
import 'package:grocery_scanner/models/product_nutriments.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_button.dart';
import 'package:grocery_scanner/screens/home/profile/shared/transparent_horizontal_button.dart';
import 'package:grocery_scanner/screens/product_creator/input_dialogs/product_creator_barcode_input_dialog.dart';
import 'package:grocery_scanner/screens/product_creator/input_dialogs/product_creator_ingredients_input_dialog.dart';
import 'package:grocery_scanner/screens/product_creator/product_creator_nutrition_table.dart';
import 'package:grocery_scanner/screens/product_creator/product_creator_tile.dart';
import 'package:grocery_scanner/screens/product_page/dialog_contents/product_nutriscore_dialog_content.dart';
import 'package:grocery_scanner/screens/product_page/product_page.dart';
import 'package:grocery_scanner/services/auth_service.dart';
import 'package:grocery_scanner/services/deepl_translator_service.dart';
import 'package:grocery_scanner/services/product_database_service.dart';
import 'package:grocery_scanner/services/user_database_service.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';
import 'package:grocery_scanner/shared/hive_boxes.dart';
import 'package:grocery_scanner/shared/label_row.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../product_page/shared/allergens_functions.dart';
import '../product_page/dialog_contents/product_allergens_dialog_content.dart';
import 'allergens_list.dart';

const _nutriscoreGrades = {"A", "B", "C", "D", "E", "?"};
Map<String, dynamic> _emptyNutriment() => {"value": "N/A", "value_100g": "N/A"};

class ProductCreator extends StatefulWidget {
  final Product? productToEdit;
  const ProductCreator({super.key, this.productToEdit});

  @override
  State<ProductCreator> createState() => _ProductCreatorState();
}

class _ProductCreatorState extends State<ProductCreator> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _firebaseStorage = FirebaseStorage.instance;
  final _imagePicker = ImagePicker();

  bool isEditMode = false;
  bool isSaveButtonLocked = false;
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
  List<Map<String, dynamic>> tags = [
    {"name": "palm_oil_free", "status": "unknown"},
    {"name": "vegetarian", "status": "unknown"},
    {"name": "vegan", "status": "unknown"}
  ];

  @override
  void initState() {
    super.initState();
    isEditMode = widget.productToEdit != null;

    if (isEditMode) {
      _fetchProductImages();

      productName = widget.productToEdit!.productName;
      brand = widget.productToEdit!.brand;
      barcode = widget.productToEdit!.barcode;
      ingredients = widget.productToEdit!.ingredients;
      allergens = widget.productToEdit!.allergens;
      nutriments = widget.productToEdit!.nutriments;
      nutriscore = widget.productToEdit!.nutriscore;
      tags = widget.productToEdit!.tags
          .map((e) => e as Map<String, dynamic>)
          .toList();
    }
  }

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
                Text(
                  isEditMode ? "Edytuj produkt" : "Dodaj nowy produkt",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
                        },
                        value:
                            isEditMode ? widget.productToEdit!.productName : "",
                      ),

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
                        },
                        value: isEditMode ? widget.productToEdit!.brand : "",
                      ),

                      // Image Tiles
                      const SizedBox(height: 10),
                      _renderTiles(),

                      const SizedBox(height: 10),
                      const Text(
                        "Uzupełnij pozostałe dane i popraw te, które zostały niedokładnie odczytane z dodanych zdjęć",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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
                                setState(() => barcode = input),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: barcode.isNotEmpty
                            ? Text(
                                barcode,
                                style: const TextStyle(fontSize: 16),
                              )
                            : const Text(
                                "Nie zeskanowano kodu kreskowego",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                      ),

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
                              await _extractAllergensFromIngredients(input);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ingredients.isNotEmpty
                            ? Text(ingredients)
                            : const Text(
                                "Nie dodano składu produktu",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                      ),
                      TransparentHorizontalButton(
                        icon: Icons.translate,
                        iconSize: 20,
                        label: "Przetłumacz na polski",
                        color: green,
                        onPressed: () async {
                          final ingredientsTranslation =
                              await DeepLTranslatorService.translate(
                                  ingredients);
                          setState(() {
                            ingredients = ingredientsTranslation.text;
                          });
                          _extractAllergensFromIngredients(
                            ingredientsTranslation.text,
                          );
                          Fluttertoast.showToast(
                            msg: "Przetłumaczono skład produktu",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 16,
                          );
                        },
                      ),

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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const ProductAllergensDialogContent(),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: black,
                                ),
                                child: const Text("OK"),
                              )
                            ],
                          ),
                        ),
                      ),
                      ProductCreatorAllergensList(
                        allergens: allergens,
                        callback: (updatedAllergens) {
                          setState(() => allergens = updatedAllergens);
                        },
                      ),

                      // Nutriments
                      const SizedBox(height: 10),
                      const LabelRow(
                          icon: Icons.fastfood_outlined,
                          labelText: "Tabela wartości odżywczych",
                          color: green,
                          isSecondaryIconEnabled: false),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jeśli któraś z wartości nie jest podana, pozostaw puste pole",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          Text(
                            "Wartości niecałkowite zapisuj z użyciem kropki (np. 3.5)",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ProductCreatorNutritionTable(
                        receivedNutriments: widget.productToEdit?.nutriments,
                        setValue: (updatedNutriments) =>
                            setState(() => nutriments = updatedNutriments),
                      ),

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
                                style: TextButton.styleFrom(
                                  foregroundColor: black,
                                ),
                                child: const Text("OK"),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _nutriscoreGrades
                            .map(
                              (e) => GestureDetector(
                                onTap: () => setState(() => nutriscore = e),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    nutriscoreTile(e),
                                    if (e.toLowerCase() ==
                                        nutriscore.toLowerCase())
                                      const Icon(
                                        Icons.keyboard_arrow_up,
                                        size: 30,
                                      )
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),

                      // Additional Info (Tags)
                      const SizedBox(height: 10),
                      const LabelRow(
                        icon: Icons.eco_outlined,
                        labelText: "Dodatkowe informacje",
                        color: green,
                        isSecondaryIconEnabled: false,
                      ),
                      _renderAdditionalInfoDropdowns(),

                      const SizedBox(height: 10),
                      _renderFormErrors(),

                      // Buttons
                      const SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Home Button
                          HorizontalButton(
                            icon: Icons.home,
                            label: "Wróć na stronę główną",
                            color: green,
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("/home");
                            },
                          ),

                          // Add / Edit Product Button
                          const SizedBox(width: 10),
                          HorizontalButton(
                            icon: isEditMode ? Icons.save : Icons.add,
                            label: _renderAddEditButtonLabel(
                                isSaveButtonLocked, isEditMode),
                            color: isSaveButtonLocked
                                ? greyButtonFullOpacity
                                : green,
                            onPressed: () async {
                              setState(() => isSaveButtonLocked = true);

                              // Check if product already exists
                              if (!isEditMode) {
                                final productChecker =
                                    await ProductDatabaseService(barcode)
                                        .getProduct();
                                if (productChecker != null) {
                                  // setState(() {
                                  //   isSaveButtonLocked = true;
                                  // });
                                  Fluttertoast.showToast(
                                    msg: "Ten produkt już został dodany",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 16,
                                  );
                                  return;
                                }

                                // if (isSaveButtonLocked) {
                                //   return;
                                // }
                              }

                              setState(() {
                                formErrorMessages.clear();
                              });

                              if (barcode == "") {
                                setState(() {
                                  isSaveButtonLocked = false;
                                  formErrorMessages
                                      .add("Dodaj kod kreskowy produktu");
                                });
                              }

                              String imageFrontUrl = "";
                              String imageIngredientsUrl = "";
                              String imageNutrimentsUrl = "";

                              if (productImageFront == null) {
                                setState(() {
                                  isSaveButtonLocked = false;
                                  formErrorMessages
                                      .add("Dodaj zdjęcie przodu produktu");
                                });
                              } else {
                                imageFrontUrl =
                                    await _uploadImageToFirebaseStorage(
                                  image: productImageFront!,
                                  type: "front",
                                  barcode: barcode,
                                );
                              }

                              if (productImageIngredients == null) {
                                setState(() {
                                  isSaveButtonLocked = false;
                                  formErrorMessages
                                      .add("Dodaj zdjęcie składu produktu");
                                });
                              } else {
                                imageIngredientsUrl =
                                    await _uploadImageToFirebaseStorage(
                                  image: productImageIngredients!,
                                  type: "ingredients",
                                  barcode: barcode,
                                );
                              }

                              if (productImageNutriments == null) {
                                setState(() {
                                  isSaveButtonLocked = false;
                                  formErrorMessages
                                      .add("Dodaj zdjęcie wartości odżywczych");
                                });
                              } else {
                                imageNutrimentsUrl =
                                    await _uploadImageToFirebaseStorage(
                                  image: productImageNutriments!,
                                  type: "nutriments",
                                  barcode: barcode,
                                );
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
                                  tags: tags,
                                );

                                // Add Product to Firestore
                                final response =
                                    await ProductDatabaseService(barcode)
                                        .addProduct(product);
                                if (response == false) {
                                  setState(() => isSaveButtonLocked = false);
                                  Fluttertoast.showToast(
                                    msg: isEditMode
                                        ? "Nie udało się zapisać produktu"
                                        : "Nie udało się dodać nowego produktu",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 16,
                                  );
                                } else {
                                  // setState(() => isSaveButtonLocked = true);

                                  // Add Product to logged user's products list
                                  if (!isEditMode) {
                                    await UserDatabaseService(
                                      _auth.currentUserUid!,
                                    ).relateUserWithProduct(barcode);
                                  }
                                  await saveProductLocally(product);

                                  Fluttertoast.showToast(
                                    msg: isEditMode
                                        ? "Zapisano produkt"
                                        : "Pomyślnie dodano nowy produkt",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 16,
                                  );

                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductPage(product),
                                    ),
                                  );
                                }
                              } else {
                                setState(() => isSaveButtonLocked = false);
                                Fluttertoast.showToast(
                                  msg: "Popraw wszystkie pola formularza",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  fontSize: 16,
                                );
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _fetchProductImages() async {
    http.Response? productImageFrontResponse;
    http.Response? productImageIngredientsResponse;
    http.Response? productImageNutrimentsResponse;

    try {
      if (widget.productToEdit!.images.front != "") {
        productImageFrontResponse =
            await http.get(Uri.parse(widget.productToEdit!.images.front));
      } else {
        productImageFrontResponse = null;
      }
    } catch (e) {
      productImageFrontResponse = null;
    }

    try {
      if (widget.productToEdit!.images.ingredients != "") {
        productImageIngredientsResponse =
            await http.get(Uri.parse(widget.productToEdit!.images.ingredients));
      } else {
        productImageIngredientsResponse = null;
      }
    } catch (e) {
      productImageIngredientsResponse = null;
    }

    try {
      if (widget.productToEdit!.images.nutrition != "") {
        productImageNutrimentsResponse =
            await http.get(Uri.parse(widget.productToEdit!.images.nutrition));
      } else {
        productImageNutrimentsResponse = null;
      }
    } catch (e) {
      productImageNutrimentsResponse = null;
    }

    final dir = await getApplicationDocumentsDirectory();

    if (productImageFrontResponse != null) {
      File productImageFrontFile =
          File("${dir.path}/temp_${widget.productToEdit!.barcode}_front.jpg");
      await productImageFrontFile
          .writeAsBytes(productImageFrontResponse.bodyBytes);
      setState(() {
        productImageFront = productImageFrontFile;
      });
    }

    if (productImageIngredientsResponse != null) {
      File productImageIngredientsFile = File(
          "${dir.path}/temp_${widget.productToEdit!.barcode}_ingredients.jpg");
      await productImageIngredientsFile
          .writeAsBytes(productImageIngredientsResponse.bodyBytes);
      setState(() {
        productImageIngredients = productImageIngredientsFile;
      });
    }

    if (productImageNutrimentsResponse != null) {
      File productImageNutrimentsFile = File(
          "${dir.path}/temp_${widget.productToEdit!.barcode}_nutrition.jpg");
      await productImageNutrimentsFile
          .writeAsBytes(productImageNutrimentsResponse.bodyBytes);
      setState(() {
        productImageNutriments = productImageNutrimentsFile;
      });
    }
  }

  Future _getImageFromCamera({required String type}) async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 95,
    );

    if (pickedImage != null) {
      await _cropImage(
        path: pickedImage.path,
        type: type,
      );
    } else {
      switch (type) {
        case "barcode":
          productImageBarcode = null;
          break;
        case "front":
          productImageFront = null;
          break;
        case "ingriedients":
          productImageIngredients = null;
          break;
        case "nutriments":
          productImageNutriments = null;
          break;
        default:
          break;
      }
    }
  }

  Future _cropImage({required String path, required String type}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Przytnij zdjęcie",
          toolbarColor: white,
          toolbarWidgetColor: green,
          backgroundColor: white,
          activeControlsWidgetColor: green,
          lockAspectRatio: false,
        )
      ],
    );

    setState(() {
      if (croppedFile != null) {
        switch (type) {
          case "barcode":
            productImageBarcode = File(croppedFile.path);
            break;
          case "front":
            productImageFront = File(croppedFile.path);
            break;
          case "ingriedients":
            productImageIngredients = File(croppedFile.path);
            break;
          case "nutriments":
            productImageNutriments = File(croppedFile.path);
            break;
          default:
            break;
        }
      }
    });
  }

  Future _readTextFromImage() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 95,
    );

    if (pickedImage != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Przytnij zdjęcie",
            toolbarColor: green,
            toolbarWidgetColor: white,
            lockAspectRatio: false,
          )
        ],
      );

      if (croppedFile != null) {
        final textRecognizer =
            TextRecognizer(script: TextRecognitionScript.latin);
        final recognizedText = await textRecognizer.processImage(
          InputImage.fromFile(File(croppedFile.path)),
        );

        setState(() {
          productImageIngredients = File(croppedFile.path);
          ingredients = recognizedText.text.replaceAll("\n", " ");
        });

        textRecognizer.close();
      }
    }
  }

  Future _extractAllergensFromIngredients(String ingredients) async {
    Set<String> extractedAllergens = {};
    Set<String> separatedCandidates = {};

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
    return Column(
      children: [
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
                        formats: [BarcodeFormat.EAN_8, BarcodeFormat.EAN_13],
                      );
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
                      await _readTextFromImage();
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
                deleteText: "Usuń zdjęcie wart. odżywczych",
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _renderAdditionalInfoDropdowns() {
    return Table(
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
      children: [
        // Palm Oil
        TableRow(
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Czy produkt zawiera olej palmowy?",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: tags[0]["status"],
                      items: const [
                        DropdownMenuItem(
                          value: "negative",
                          child: Text("Tak"),
                        ),
                        DropdownMenuItem(
                          value: "positive",
                          child: Text("Nie"),
                        ),
                        DropdownMenuItem(
                          value: "unknown",
                          child: Text("Nie wiem"),
                        )
                      ],
                      isDense: true,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      onChanged: (val) {
                        setState(() => tags[0]["status"] = val ?? "unknown");
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),

        // Vegetarian
        TableRow(
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "Czy produkt jest wegetariański?",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: tags[1]["status"],
                      items: const [
                        DropdownMenuItem(
                          value: "positive",
                          child: Text("Tak"),
                        ),
                        DropdownMenuItem(
                          value: "negative",
                          child: Text("Nie"),
                        ),
                        DropdownMenuItem(
                          value: "maybe",
                          child: Text("Może nie być"),
                        ),
                        DropdownMenuItem(
                          value: "unknown",
                          child: Text("Nie wiem"),
                        )
                      ],
                      isDense: true,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      onChanged: (val) {
                        setState(() => tags[1]["status"] = val ?? "unknown");
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),

        // Vegan
        TableRow(
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "Czy produkt jest wegański?",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: tags[2]["status"],
                      items: const [
                        DropdownMenuItem(
                          value: "positive",
                          child: Text("Tak"),
                        ),
                        DropdownMenuItem(
                          value: "negative",
                          child: Text("Nie"),
                        ),
                        DropdownMenuItem(
                          value: "maybe",
                          child: Text("Może nie być"),
                        ),
                        DropdownMenuItem(
                          value: "unknown",
                          child: Text("Nie wiem"),
                        )
                      ],
                      isDense: true,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      onChanged: (val) {
                        setState(() => tags[2]["status"] = val ?? "unknown");
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _renderFormErrors() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: formErrorMessages
              .map(
                (e) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: red),
                    const SizedBox(width: 5),
                    Text(e, style: const TextStyle(color: red))
                  ],
                ),
              )
              .toList(),
        )
      ],
    );
  }

  Future _uploadImageToFirebaseStorage({
    required File image,
    required String type,
    required String barcode,
  }) async {
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

String _renderAddEditButtonLabel(bool isSaveButtonLocked, bool isEditMode) {
  if (isEditMode && isSaveButtonLocked) return "Zapisywanie produktu...";
  if (!isEditMode && isSaveButtonLocked) return "Dodawanie produktu...";
  if (isEditMode && !isSaveButtonLocked) return "Zapisz zmiany";
  if (!isEditMode && !isSaveButtonLocked) return "Dodaj produkt";
  return "";
}
