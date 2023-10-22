import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/screens/product/shared/full_screen_image.dart';
import 'package:grocery_scanner/screens/product/product_not_found.dart';
import 'package:grocery_scanner/screens/product/shared/product_nutriscore_dialog_content.dart';
import 'package:grocery_scanner/services/open_food_facts.dart';
import 'package:grocery_scanner/services/user_database.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/label_row.dart';
import 'package:grocery_scanner/shared/loading.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage(this.product, {super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    String url = widget.product.images.front;

    const nutriscoreGrades = {"A", "B", "C", "D", "E"};

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context, builder: (_) => FullScreenImage(url));
              },
              // onTap: () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (_) => FullScreenImage(url)));
              // },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(url))),
                child: OverflowBox(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: 300,
                  child: SafeArea(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, "/home");
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.topLeft),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: blackOpacity,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 30.0,
                                      color: white,
                                    ),
                                  )),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.topRight),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: blackOpacity,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(7.0),
                                    child: Icon(
                                      Icons.edit,
                                      size: 25.0,
                                      color: white,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.bottomLeft),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: blackOpacity,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0))),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.push_pin,
                                      color: white,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      "Przypnij",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (nutriscoreGrades.contains(
                              widget.product.nutriscore.toUpperCase()))
                            TextButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                            "Wskaźnik Nutri-Score",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                        content:
                                            const ProductNutriscoreDialogContent(),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: TextButton.styleFrom(
                                                foregroundColor: black),
                                            child: const Text("OK"),
                                          )
                                        ],
                                      )),
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.bottomRight),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: nutriscoreColor(
                                        widget.product.nutriscore),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    " ${widget.product.nutriscore.toUpperCase()} ",
                                    style: const TextStyle(
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.bold,
                                        color: white),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25.0),
                    Text(
                      widget.product.productName,
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.product.brand,
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 20.0),
                    _determineIfProductIsProper(),
                    const SizedBox(height: 20.0),
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
                    // product.translateIngredients(),
                    // Text(translatedIngredients!),
                    const SizedBox(height: 15.0),
                    const LabelRow(
                      icon: Icons.egg_outlined,
                      labelText: "Alergeny",
                      color: green,
                      isSecondaryIconEnabled: false,
                    ),
                    Text(widget.product.allergens),
                    // product.translateAllergens(),
                    const SizedBox(height: 15.0),
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
                    const SizedBox(height: 5.0),
                    widget.product.nutriments.renderTable(),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

    // final user = Provider.of<User?>(context)!;

    // return Scaffold(
    //   body: FutureBuilder(
    //     future: product,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Loading();
    //       }
    //       if (!snapshot.hasData) {
    //         return const ProductNotFound();
    //       } else {
    //         if (snapshot.data == null) {
    //           return const ProductNotFound();
    //         }
    //         // String name = snapshot.data!.productName;
    //         // return Text(name);
    //         final product = snapshot.data!;
    //         String url = product.images.front;

    //         const nutriscoreGrades = {"A", "B", "C", "D", "E"};

    //         return Scaffold(
    //           body: SingleChildScrollView(
    //             child: Column(
    //               children: [
    //                 GestureDetector(
    //                   onTap: () async {
    //                     await showDialog(
    //                         context: context,
    //                         builder: (_) => FullScreenImage(url));
    //                   },
    //                   // onTap: () {
    //                   //   Navigator.push(
    //                   //       context,
    //                   //       MaterialPageRoute(
    //                   //           builder: (_) => FullScreenImage(url)));
    //                   // },
    //                   child: Container(
    //                     width: MediaQuery.of(context).size.width,
    //                     height: 300,
    //                     decoration: BoxDecoration(
    //                         image: DecorationImage(
    //                             fit: BoxFit.cover, image: NetworkImage(url))),
    //                     child: OverflowBox(
    //                       maxWidth: MediaQuery.of(context).size.width,
    //                       maxHeight: 300,
    //                       child: SafeArea(
    //                           child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.all(10.0),
    //                             child: Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 TextButton(
    //                                   onPressed: () {
    //                                     Navigator.pop(context);
    //                                     Navigator.pushNamed(context, "/home");
    //                                   },
    //                                   style: TextButton.styleFrom(
    //                                       padding: EdgeInsets.zero,
    //                                       alignment: Alignment.topLeft),
    //                                   child: Container(
    //                                       decoration: const BoxDecoration(
    //                                           color: blackOpacity,
    //                                           borderRadius: BorderRadius.all(
    //                                               Radius.circular(30.0))),
    //                                       child: const Padding(
    //                                         padding: EdgeInsets.all(5.0),
    //                                         child: Icon(
    //                                           Icons.arrow_back,
    //                                           size: 30.0,
    //                                           color: white,
    //                                         ),
    //                                       )),
    //                                 ),
    //                                 TextButton(
    //                                   onPressed: () {},
    //                                   style: TextButton.styleFrom(
    //                                       padding: EdgeInsets.zero,
    //                                       alignment: Alignment.topRight),
    //                                   child: Container(
    //                                       decoration: const BoxDecoration(
    //                                           color: blackOpacity,
    //                                           borderRadius: BorderRadius.all(
    //                                               Radius.circular(30.0))),
    //                                       child: const Padding(
    //                                         padding: EdgeInsets.all(7.0),
    //                                         child: Icon(
    //                                           Icons.edit,
    //                                           size: 25.0,
    //                                           color: white,
    //                                         ),
    //                                       )),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           Row(
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceBetween,
    //                             crossAxisAlignment: CrossAxisAlignment.end,
    //                             children: [
    //                               TextButton(
    //                                 onPressed: () {},
    //                                 style: TextButton.styleFrom(
    //                                     padding: EdgeInsets.zero,
    //                                     alignment: Alignment.bottomLeft),
    //                                 child: Container(
    //                                   decoration: const BoxDecoration(
    //                                       color: blackOpacity,
    //                                       borderRadius: BorderRadius.only(
    //                                           topRight: Radius.circular(10.0))),
    //                                   child: const Padding(
    //                                     padding: EdgeInsets.all(10.0),
    //                                     child: Row(
    //                                       children: [
    //                                         Icon(
    //                                           Icons.push_pin,
    //                                           color: white,
    //                                         ),
    //                                         SizedBox(width: 5.0),
    //                                         Text(
    //                                           "Przypnij",
    //                                           style: TextStyle(
    //                                               fontSize: 16.0,
    //                                               fontWeight: FontWeight.bold,
    //                                               color: white),
    //                                         )
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                               if (nutriscoreGrades.contains(
    //                                   product.nutriscore.toUpperCase()))
    //                                 TextButton(
    //                                   onPressed: () => showDialog(
    //                                       context: context,
    //                                       builder: (context) => AlertDialog(
    //                                             title: const Text(
    //                                                 "Wskaźnik Nutri-Score",
    //                                                 style: TextStyle(
    //                                                     fontSize: 20.0,
    //                                                     fontWeight:
    //                                                         FontWeight.bold)),
    //                                             content:
    //                                                 const ProductNutriscoreDialogContent(),
    //                                             actions: [
    //                                               TextButton(
    //                                                 onPressed: () =>
    //                                                     Navigator.pop(context),
    //                                                 style: TextButton.styleFrom(
    //                                                     foregroundColor: black),
    //                                                 child: const Text("OK"),
    //                                               )
    //                                             ],
    //                                           )),
    //                                   style: TextButton.styleFrom(
    //                                       padding: EdgeInsets.zero,
    //                                       alignment: Alignment.bottomRight),
    //                                   child: Container(
    //                                     decoration: BoxDecoration(
    //                                         color: nutriscoreColor(
    //                                             product.nutriscore),
    //                                         borderRadius:
    //                                             const BorderRadius.only(
    //                                                 topLeft:
    //                                                     Radius.circular(10.0))),
    //                                     child: Padding(
    //                                       padding: const EdgeInsets.all(15.0),
    //                                       child: Text(
    //                                         " ${product.nutriscore.toUpperCase()} ",
    //                                         style: const TextStyle(
    //                                             fontSize: 26.0,
    //                                             fontWeight: FontWeight.bold,
    //                                             color: white),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 )
    //                             ],
    //                           ),
    //                         ],
    //                       )),
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //                   child: SizedBox(
    //                     width: MediaQuery.of(context).size.width,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const SizedBox(height: 25.0),
    //                         Text(
    //                           product.productName,
    //                           style: const TextStyle(
    //                               fontSize: 24.0, fontWeight: FontWeight.bold),
    //                         ),
    //                         Text(
    //                           product.brand,
    //                           style: const TextStyle(fontSize: 18.0),
    //                         ),
    //                         const SizedBox(height: 20.0),
    //                         _determineIfProductIsProper(),
    //                         const SizedBox(height: 20.0),
    //                         LabelRow(
    //                           icon: Icons.list_alt,
    //                           labelText: "Skład produktu",
    //                           color: green,
    //                           isSecondaryIconEnabled: true,
    //                           secondaryIcon: Icons.image_outlined,
    //                           onTap: () async {
    //                             await showDialog(
    //                                 context: context,
    //                                 builder: (_) => FullScreenImage(
    //                                     product.images.ingredients));
    //                           },
    //                         ),
    //                         Text(product.ingredients),
    //                         // product.translateIngredients(),
    //                         // Text(translatedIngredients!),
    //                         const SizedBox(height: 15.0),
    //                         const LabelRow(
    //                           icon: Icons.egg_outlined,
    //                           labelText: "Alergeny",
    //                           color: green,
    //                           isSecondaryIconEnabled: false,
    //                         ),
    //                         Text(product.allergens),
    //                         // product.translateAllergens(),
    //                         const SizedBox(height: 15.0),
    //                         LabelRow(
    //                           icon: Icons.fastfood_outlined,
    //                           labelText: "Wartości odżywcze",
    //                           color: green,
    //                           isSecondaryIconEnabled: true,
    //                           secondaryIcon: Icons.photo_outlined,
    //                           onTap: () async {
    //                             await showDialog(
    //                                 context: context,
    //                                 builder: (_) => FullScreenImage(
    //                                     product.images.nutrition));
    //                           },
    //                         ),
    //                         const SizedBox(height: 5.0),
    //                         product.nutriments.renderTable(),
    //                         const SizedBox(height: 20.0),
    //                       ],
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         );
    //       }
    //     },
    //   ),
    // );
  }

  Widget _determineIfProductIsProper() {
    bool isProper = false;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5.0),
      decoration: isProper
          ? const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: green)
          : const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: red),
      child: Row(
        children: [
          (isProper
              ? const Icon(Icons.check_circle_outlined, color: white)
              : const Icon(
                  Icons.cancel_outlined,
                  color: white,
                )),
          const SizedBox(
            width: 5.0,
          ),
          (isProper
              ? const Text(
                  "Produkt jest dla Ciebie odpowiedni!",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: white),
                )
              : const Text("Produkt nie jest dla Ciebie odpowiedni!",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: white)))
        ],
      ),
    );
  }
}
