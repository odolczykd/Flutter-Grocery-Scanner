import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class HorizontalButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final void Function() onPressed;

  const HorizontalButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed,
      this.color = black});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: white,
              side: BorderSide(color: color, width: 2),
              shadowColor: Colors.transparent,
              minimumSize: const Size.fromHeight(50),
              foregroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: color,
          ),
          label: Text(
            label.toUpperCase(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
    );
  }
}
