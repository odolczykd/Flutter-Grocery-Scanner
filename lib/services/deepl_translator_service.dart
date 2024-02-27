// ignore_for_file: constant_identifier_names, unnecessary_this

import 'dart:convert';
import 'package:grocery_scanner/auth/secrets.dart';
import 'package:http/http.dart' as http;

const DEEPL_API_URL = "https://api-free.deepl.com/v2/translate";

class DeepLTranslatorService {
  static Future<TranslationResult> translate(String sourceText) async {
    if (sourceText.isEmpty) {
      return TranslationResult(
        text: "",
        detectedSourceLang: "N/A",
      );
    }

    final response = await http.post(
      Uri.parse(DEEPL_API_URL),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "DeepL-Auth-Key $deepL_apiKey"
      },
      body: jsonEncode(
        <String, dynamic>{
          "text": [sourceText],
          "target_lang": "PL"
        },
      ),
    );

    if (response.statusCode == 200) {
      var decodedTranslation =
          json.decode(utf8.decode(response.bodyBytes))["translations"][0];
      if ("PL"
          .compareIgnoreCase(decodedTranslation["detected_source_language"])) {
        return TranslationResult(
          text: sourceText,
          detectedSourceLang: "PL",
        );
      } else {
        return TranslationResult.fromJson(decodedTranslation);
      }
    } else {
      return TranslationResult(
        text: sourceText,
        detectedSourceLang: "N/A",
      );
    }
  }
}

class TranslationResult {
  final String text;
  final String detectedSourceLang;

  TranslationResult({required this.text, required this.detectedSourceLang});

  factory TranslationResult.fromJson(Map<String, dynamic> json) {
    return TranslationResult(
        text: json["text"],
        detectedSourceLang:
            json["detected_source_language"].toString().toLowerCase());
  }
}

extension CompareIgnoreCase on String {
  bool compareIgnoreCase(String other) {
    return this.toLowerCase() == other.toLowerCase();
  }
}
