import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/product/product_creator/product_creator_tile.dart';
import 'package:grocery_scanner/services/auth.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';

class ProductCreator extends StatefulWidget {
  final String? productBarcode;
  const ProductCreator({super.key, this.productBarcode});

  @override
  State<ProductCreator> createState() => _ProductCreatorState();
}

class _ProductCreatorState extends State<ProductCreator> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final tilesInformation = const [
    (icon: Icons.qr_code_scanner, text: "Zeskanuj kod kreskowy"),
    (icon: Icons.lunch_dining, text: "Dodaj zdjęcie produktu (przód)"),
    (icon: Icons.format_list_bulleted, text: "Dodaj zdjęcie składu produktu"),
    (icon: Icons.fastfood, text: "Dodaj zdjęcie wartości odżywczych"),
  ];

  Widget _buildTiles() {
    List<Widget> tileRows = [];

    for (var i = 0; i < tilesInformation.length; i += 2) {
      tileRows.add(Row(
        children: [
          Expanded(
            flex: 1,
            child: ProductCreatorTile(
                icon: tilesInformation[i].icon,
                text: tilesInformation[i].text,
                position: TilePosition.left),
          ),
          Expanded(
            flex: 1,
            child: ProductCreatorTile(
                icon: tilesInformation[i + 1].icon,
                text: tilesInformation[i + 1].text,
                position: TilePosition.right),
          )
        ],
      ));
    }

    return Column(children: tileRows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dodaj nowy produkt",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    FormTextField(
                        labelText: "Nazwa produktu",
                        color: green,
                        obscureText: false,
                        validator: (val) {}),
                    const SizedBox(height: 10.0),
                    FormTextField(
                        labelText: "Marka",
                        color: green,
                        obscureText: false,
                        validator: (val) {}),
                    const SizedBox(height: 10.0),
                    FormTextField(
                        labelText: "Kraj pochodzenia",
                        color: green,
                        obscureText: false,
                        validator: (val) {}),
                    const SizedBox(height: 10),
                    // const Text(
                    //     "Korzystając z poniższych przycisków, zrób zdjęcia produktu, aby uzyskać dane na ich temat",
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold, fontSize: 16)),
                    // const SizedBox(height: 5),
                    _buildTiles(),
                    const SizedBox(height: 10),
                    const Text(
                        "Uzupełnij pozostałe dane i popraw te, które zostały błędnie odczytane z dodanych zdjęć",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10.0),
                    FormTextField(
                      labelText: "Kod kreskowy",
                      color: green,
                      obscureText: false,
                      validator: (val) {},
                      value: "[tu wstaw odczytany kod kreskowy]",
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ))
          ],
        ),
      ),
    )));
  }
}
