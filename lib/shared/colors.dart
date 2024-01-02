import 'package:flutter/material.dart';

const Color white = Colors.white;
const Color black = Colors.black;
const Color grey = Color(0xFF9E9E9E);
const Color greyButton = Color(0x46A8A8A8);
const Color greyButtonFullOpacity = Color(0xFF5F5F5F);
const Color greyBg = Color(0xFFEEEEEE);
const Color green = Color(0xFF4FB000);
const Color orange = Color(0xFFEF6C00);
const Color red = Color(0xFFD32F2F);
const Color blackOpacity = Color(0x7D000000);

const Color nutriscoreA = Color(0xC7038141);
const Color nutriscoreB = Color(0xC785BB2F);
const Color nutriscoreC = Color(0xC7E6B802);
const Color nutriscoreD = Color(0xC7EE8100);
const Color nutriscoreE = Color(0xC7E63E11);
const Color nutriscoreUnknown = Color(0xC71186DF);

Color nutriscoreColor(String nutriscoreGrade) {
  switch (nutriscoreGrade.toLowerCase()) {
    case "a":
      return nutriscoreA;
    case "b":
      return nutriscoreB;
    case "c":
      return nutriscoreC;
    case "d":
      return nutriscoreD;
    case "e":
      return nutriscoreE;
    default:
      return nutriscoreUnknown;
  }
}

Widget nutriscoreTile(String nutriscoreGrade) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: nutriscoreColor(nutriscoreGrade)),
    width: 50,
    height: 50,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            nutriscoreGrade.toUpperCase(),
            style: const TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: white),
          ),
        ],
      ),
    ),
  );
}
