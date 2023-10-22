import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/screens/product/product_page.dart';
import 'package:grocery_scanner/screens/product/product_fetcher_api.dart';
import 'package:grocery_scanner/services/product_database.dart';
import 'package:grocery_scanner/shared/loading.dart';

class ProductFetcherLocal extends StatefulWidget {
  final String? barcode;
  const ProductFetcherLocal(this.barcode, {super.key});

  @override
  State<ProductFetcherLocal> createState() => _ProductFetcherLocalState();
}

class _ProductFetcherLocalState extends State<ProductFetcherLocal> {
  late Future<Product?> productFuture;

  @override
  void initState() {
    super.initState();
    if (widget.barcode == null) {
      productFuture = Future.value(null);
    } else {
      productFuture = ProductDatabaseService(widget.barcode!).getProduct();
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
          return ProductPage(product);
        } else {
          return ProductFetcherApi(widget.barcode);
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
