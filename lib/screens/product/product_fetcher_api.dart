import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart' as product_model;
import 'package:grocery_scanner/screens/product/product_page.dart';
import 'package:grocery_scanner/screens/product/product_not_found.dart';
import 'package:grocery_scanner/services/open_food_facts.dart';
import 'package:grocery_scanner/services/product_database.dart';
import 'package:grocery_scanner/shared/loading.dart';

class ProductFetcherApi extends StatefulWidget {
  final String? barcode;
  const ProductFetcherApi(this.barcode, {super.key});

  @override
  State<ProductFetcherApi> createState() => _ProductFetcherApiState();
}

class _ProductFetcherApiState extends State<ProductFetcherApi> {
  late Future<product_model.Product?> productFuture;

  @override
  void initState() {
    super.initState();
    if (widget.barcode == null) {
      productFuture = Future.value(null);
    } else {
      productFuture = OpenFoodFacts.fetchProductByBarcode(widget.barcode!);
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
        if (snapshot.hasData) {
          final product = snapshot.data!;
          ProductDatabaseService(product.barcode).addProduct(product);
          return ProductPage(product);
        } else {
          return const ProductNotFound();
        }
      },
    );

    // Firstly, check if product is in local database

    // Secondly,
    // * get the API request
    // * transform request to Product class
    // * save it in local database
  }
}
