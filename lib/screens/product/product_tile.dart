import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: 100.0,
        height: 75.0,
        child: Column(children: []),
      ),
    );
  }
}
