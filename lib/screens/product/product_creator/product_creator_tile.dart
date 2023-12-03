import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class ProductCreatorTile extends StatelessWidget {
  final TilePosition position;
  final IconData icon;
  final String text;
  final void Function()? onPressed;
  final File? image;
  final String? deleteText;
  final void Function()? onDelete;

  const ProductCreatorTile(
      {super.key,
      required this.icon,
      required this.text,
      required this.position,
      required this.onPressed,
      this.image,
      this.deleteText,
      this.onDelete});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: onPressed,
      child: Padding(
        padding: position == TilePosition.left
            ? const EdgeInsets.fromLTRB(0, 5, 5, 5)
            : const EdgeInsets.fromLTRB(5, 5, 0, 5),
        child: Container(
          width: double.maxFinite,
          decoration: image != null
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: black,
                  image: DecorationImage(
                      image: FileImage(image!),
                      fit: BoxFit.cover,
                      opacity: 0.7))
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: green),
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                image == null
                    ? Icon(
                        icon,
                        color: white,
                        size: 35.0,
                      )
                    : const Icon(
                        Icons.delete,
                        color: white,
                        size: 35.0,
                      ),
                const SizedBox(height: 5),
                image == null
                    ? Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )
                    : Text(
                        deleteText!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum TilePosition { left, right }
