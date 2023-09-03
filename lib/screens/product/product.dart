import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart' as product_model;
import 'package:grocery_scanner/screens/product/full_screen_image.dart';
import 'package:grocery_scanner/screens/product/product_not_found.dart';
import 'package:grocery_scanner/services/open_food_facts.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/label_row.dart';
import 'package:grocery_scanner/shared/loading.dart';
// import 'package:translator/translator.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late Future<product_model.Product?> product;
  String? alergens;

  @override
  void initState() {
    super.initState();
    // product = OpenFoodFacts().fetchProductByBarcode("5900820011529");
    product = OpenFoodFacts().fetchProductByBarcode("8714100666920");
    // product = OpenFoodFacts().fetchProductByBarcode("5900820011528");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (!snapshot.hasData) {
            return const ProductNotFound();
          } else {
            if (snapshot.data == null) {
              return const ProductNotFound();
            }
            // String name = snapshot.data!.productName;
            // return Text(name);
            final product = snapshot.data!;
            String url = product.images.front;

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => FullScreenImage(url));
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
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
                                    Container(
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
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
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
                                  Container(
                                    decoration: BoxDecoration(
                                        color:
                                            nutriscoreColor(product.nutriscore),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            product.nutriscore.length > 1
                                                ? "?"
                                                : product.nutriscore
                                                    .toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 26.0,
                                                fontWeight: FontWeight.bold,
                                                color: white),
                                          ),
                                          const SizedBox(height: 5.0),
                                          const Text("Nutriscore",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: white)),
                                        ],
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
                              product.productName,
                              style: const TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              product.brand,
                              style: const TextStyle(fontSize: 16.0),
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
                                        product.images.ingredients));
                              },
                            ),
                            Text(product.ingredients),
                            const SizedBox(height: 15.0),
                            const LabelRow(
                              icon: Icons.egg_outlined,
                              labelText: "Alergeny",
                              color: green,
                              isSecondaryIconEnabled: false,
                            ),
                            Text(product.allergens),
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
                                        product.images.nutrition));
                              },
                            ),
                            const SizedBox(height: 10.0),
                            product.nutriments.renderTable(),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _determineIfProductIsProper() {
    bool isProper = true;

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
