import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/screens/product_page/product_page.dart';
import 'package:grocery_scanner/screens/product_page/product_fetcher_api.dart';
import 'package:grocery_scanner/services/product_database_service.dart';
import 'package:grocery_scanner/shared/loading.dart';

class ProductFetcherDatabase extends StatefulWidget {
  final String? barcode;
  const ProductFetcherDatabase(this.barcode, {super.key});

  @override
  State<ProductFetcherDatabase> createState() => _ProductFetcherDatabaseState();
}

class _ProductFetcherDatabaseState extends State<ProductFetcherDatabase> {
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
  }
}
