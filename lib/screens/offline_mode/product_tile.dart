import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/offline_mode/offline_product_page.dart';
import 'package:grocery_scanner/screens/product_creator/product_creator_tile.dart';
import 'package:grocery_scanner/shared/colors.dart';

class ProductTile extends StatelessWidget {
  final UserData? user;
  final ProductOffline product;
  final TilePosition position;

  const ProductTile({
    super.key,
    required this.user,
    required this.product,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OfflineProductPage(
            user: user,
            product: product,
          ),
        ),
      ),
      child: Padding(
        padding: position == TilePosition.left
            ? const EdgeInsets.fromLTRB(0, 5, 5, 5)
            : const EdgeInsets.fromLTRB(5, 5, 0, 5),
        child: Container(
          width: double.maxFinite,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: product.images.front != null
                  ? MemoryImage(Uint8List.fromList(product.images.front!))
                  : const AssetImage("assets/img/no_image.png")
                      as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: const BoxDecoration(
                  color: blackOpacity,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.productName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
