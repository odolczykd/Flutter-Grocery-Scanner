import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class AddNewProductTile extends StatelessWidget {
  const AddNewProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/product/add");
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: green),
          child: const Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: white,
                  size: 50,
                ),
                Text(
                  "Dodaj nowy produkt",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
