import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class ProductCreatorTile extends StatelessWidget {
  final TilePosition position;
  final IconData icon;
  final String text;

  const ProductCreatorTile(
      {super.key,
      required this.icon,
      required this.text,
      required this.position});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: position == TilePosition.left
          ? const EdgeInsets.fromLTRB(0, 5, 5, 5)
          : const EdgeInsets.fromLTRB(5, 5, 0, 5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: green),
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: white,
                size: 35.0,
              ),
              const SizedBox(height: 5),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: white, fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum TilePosition { left, right }
