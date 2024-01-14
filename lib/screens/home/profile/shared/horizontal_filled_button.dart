import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class HorizontalFilledButton extends StatelessWidget {
  final String label;
  final Color color;
  final void Function() onPressed;

  const HorizontalFilledButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.color = black});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                side: BorderSide(color: color, width: 2),
                shadowColor: Colors.transparent,
                minimumSize: const Size.fromHeight(50),
                foregroundColor: white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: onPressed,
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )));
  }
}
