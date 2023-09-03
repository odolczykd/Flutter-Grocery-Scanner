import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class HorizontalButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function() onPressed;
  final Color color;

  const HorizontalButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed,
      this.color = black});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: greyButton,
            shadowColor: Colors.transparent,
            minimumSize: const Size.fromHeight(40.0),
            foregroundColor: black),
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: color,
        ),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16.0),
        ));
  }
}
