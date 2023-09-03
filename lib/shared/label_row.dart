import 'package:flutter/material.dart';

class LabelRow extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final Color color;
  final void Function()? onTap;
  final bool isSecondaryIconEnabled;
  final IconData? secondaryIcon;

  const LabelRow(
      {super.key,
      required this.icon,
      required this.labelText,
      required this.color,
      required this.isSecondaryIconEnabled,
      this.secondaryIcon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 5.0),
        Text(
          labelText,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        if (isSecondaryIconEnabled) const Spacer(),
        if (isSecondaryIconEnabled)
          GestureDetector(
              onTap: onTap, child: Icon(secondaryIcon, color: color))
      ],
    );
  }
}
