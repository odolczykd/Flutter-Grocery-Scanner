import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/offline_mode/product_tile.dart';
import 'package:grocery_scanner/screens/product_creator/product_creator_tile.dart';

class ProductTilesGrid extends StatelessWidget {
  final UserData? user;
  final List<ProductOffline> products;

  const ProductTilesGrid({
    super.key,
    required this.user,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Póki co nic tu nie ma...",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Przeglądaj i przypinaj produkty, gdy masz dostęp do Internetu, a będą się one wyświetlać w tej sekcji",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    List<Widget> tiles = [];
    for (int i = 0; i < products.length; i += 2) {
      final row = Row(
        children: [
          Expanded(
            flex: 1,
            child: ProductTile(
              user: user,
              product: products[i],
              position: TilePosition.left,
            ),
          ),
          if (i < products.length - 1)
            Expanded(
              flex: 1,
              child: ProductTile(
                user: user,
                product: products[i + 1],
                position: TilePosition.right,
              ),
            )
          else
            const Expanded(flex: 1, child: SizedBox(width: 0))
        ],
      );

      tiles.add(row);
    }

    return Column(children: tiles);
  }
}
