import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class TransparentHorizontalButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String label;
  final void Function() onPressed;
  final Color color;

  const TransparentHorizontalButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.label,
    required this.onPressed,
    this.color = black,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          alignment: Alignment.centerRight,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(40),
          padding: const EdgeInsets.all(0),
          foregroundColor: green),
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
