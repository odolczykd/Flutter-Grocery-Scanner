import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class ProductTags extends StatelessWidget {
  final List tags;

  const ProductTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Palm Oil
      Row(children: [
        _pickIcon(tags[0]["status"]!),
        const SizedBox(width: 5),
        Text(_decodeStatus(tags[0]["name"]!, tags[0]["status"]!))
      ]),

      // Vegetarian
      Row(children: [
        _pickIcon(tags[1]["status"]!),
        const SizedBox(width: 5),
        Text(_decodeStatus(tags[1]["name"]!, tags[1]["status"]!))
      ]),

      // Vegan
      Row(children: [
        _pickIcon(tags[2]["status"]!),
        const SizedBox(width: 5),
        Text(_decodeStatus(tags[2]["name"]!, tags[2]["status"]!))
      ])
    ]);
  }
}

Icon _pickIcon(String status) {
  switch (status) {
    case "positive":
      return const Icon(Icons.check_circle_outline, color: green);
    case "negative":
      return const Icon(Icons.cancel_outlined, color: red);
    case "maybe":
      return const Icon(Icons.error_outline, color: nutriscoreC);
    default:
      return const Icon(Icons.help_outline, color: nutriscoreUnknown);
  }
}

String _decodeStatus(String name, String status) {
  if (name == "palm_oil_free") {
    switch (status) {
      case "positive":
        return "produkt nie zawiera oleju palmowego";
      case "negative":
        return "produkt zawiera olej palmowy";
      default:
        return "nieznany status obecności oleju palmowego";
    }
  } else if (name == "vegetarian") {
    switch (status) {
      case "positive":
        return "produkt jest wegetariański";
      case "negative":
        return "produkt nie jest wegetariański";
      case "maybe":
        return "produkt może nie być wegetariański";
      default:
        return "nie wiadomo, czy produkt jest wegetariański";
    }
  } else if (name == "vegan") {
    switch (status) {
      case "positive":
        return "produkt jest wegański";
      case "negative":
        return "produkt nie jest wegański";
      case "maybe":
        return "produkt może nie być wegański";
      default:
        return "nie wiadomo, czy produkt jest wegański";
    }
  } else {
    return "";
  }
}
