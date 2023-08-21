import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery_scanner/shared/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  static const Color green = Color(0xFF4FB000);
  static const Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      color: greyBg,
      child: const SpinKitThreeBounce(
        color: green,
        size: 50.0,
      ),
    );
  }
}
