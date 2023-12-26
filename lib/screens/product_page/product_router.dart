import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/screens/product_page/product_not_found.dart';
import 'package:grocery_scanner/screens/product_page/product_page.dart';

class ProductRouter extends StatelessWidget {
  const ProductRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final Product? product =
        ModalRoute.of(context)?.settings.arguments as Product?;

    if (product == null) {
      return const ProductNotFound();
    } else {
      return ProductPage(product);
    }
  }
}
