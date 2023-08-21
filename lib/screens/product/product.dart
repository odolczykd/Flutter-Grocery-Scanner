import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart' as product_model;
import 'package:grocery_scanner/services/open_food_facts.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/loading.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late Future<product_model.Product> product;

  @override
  void initState() {
    super.initState();
    product = OpenFoodFacts().fetchProductByBarcode("5900820011529");
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
          if (snapshot.hasData) {
            // String name = snapshot.data!.productName;
            // return Text(name);
            final product = snapshot.data!;
            String url = product.images.front;
            return Scaffold(
              body: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenImage(url)));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage(url))),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Text(product.productName),
                  const SizedBox(height: 25.0),
                  Text(product.brand),
                  const SizedBox(height: 25.0),
                  Text(product.ingredients),
                  const SizedBox(height: 25.0),
                  Text(product.allergens),
                ],
              ),
            );
          } else {
            return const Text("Nie znaleziono");
          }
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          backgroundColor: blackOpacity,
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Icon(Icons.close), Image.network(imageUrl)]),
          )),
    ));
  }
}
