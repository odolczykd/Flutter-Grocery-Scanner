import 'dart:convert';

import 'package:flutter/services.dart';

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
