import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_scanner/shared/colors.dart';

// Future<Set> extractAllergensFromIngredients(String ingredients,
//     [String auxiliaryAllergens = ""]) async {
//   Set allergens = {};

//   final json = await readJsonFile("assets/data/allergens.json");

//   var separatedCandidates =
//       auxiliaryAllergens.split(", ").map((e) => e.trim()).toSet();
//   final extractedFromIngredients = separateWords(ingredients);
//   separatedCandidates.addAll(extractedFromIngredients);

//   for (String allergen in separatedCandidates) {
//     for (String key in json.keys) {
//       List<dynamic> keywords = json[key]["keywords"];
//       for (String keyword in keywords) {
//         if (RegExp("^$keyword").hasMatch(allergen)) {
//           allergens.add(key);
//         }
//       }
//     }
//   }

//   return allergens;
// }

// Widget displayAllergens(Set allergens) {
//   Map<String, String> allergenLabels = {
//     "gluten": "zboża zawierające gluten i produkty pochodne",
//     "shellfish": "skorupiaki i produkty pochodne",
//     "eggs": "jaja i produkty pochodne",
//     "fish": "ryby i produkty pochodne",
//     "peanuts": "orzeszki ziemne (arachidowe) i produkty pochodne",
//     "soya": "soja i produkty pochodne",
//     "milk": "mleko i produkty pochodne, laktoza",
//     "nuts": "orzechy i produkty pochodne",
//     "celery": "seler i produkty pochodne",
//     "mustard": "gorczyca i produkty pochodne",
//     "sesame_seeds": "nasiona sezamu i produkty pochodne",
//     "sulphur_dioxide": "dwutlenek siarki, siarczyny i produkty pochodne",
//     "lupin": "łubin i produkty pochodne",
//     "molluscs": "mięczaki i produkty pochodne"
//   };

//   if (allergens.isEmpty) {
//     return const Text(
//       "Produkt nie zawiera alergenów.",
//       style: TextStyle(fontStyle: FontStyle.italic),
//     );
//   }

//   return Column(
//     children: allergens
//         .map((e) => Row(
//               children: [
//                 const SizedBox(width: 20),
//                 const Icon(
//                   Icons.navigate_next,
//                   color: green,
//                 ),
//                 Text(allergenLabels[e]!)
//               ],
//             ))
//         .toList(),
//   );
// }

Future<Map<String, dynamic>> readJsonFile(String filePath) async {
  final file = await rootBundle.loadString(filePath);
  return jsonDecode(file);
}

List<String> separateWords(String? text) {
  const separateRuleRegex =
      r"[^\p{Alphabetic}\p{Mark}\p{Connector_Punctuation}\p{Join_Control}\s]+";
  return text == null
      ? []
      : text
          .replaceAll(RegExp(separateRuleRegex, unicode: true), "")
          .split(" ")
          .where((e) => e.isNotEmpty)
          .map((e) => e.trim())
          .map((e) => e.toLowerCase())
          .toList();
}
