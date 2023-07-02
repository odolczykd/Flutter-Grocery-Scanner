import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  static const Color green = Color(0xFF4FB000);
  static const Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: green,
      child: const SpinKitThreeBounce(
        color: white,
        size: 50.0,
      ),
    );
  }
}
