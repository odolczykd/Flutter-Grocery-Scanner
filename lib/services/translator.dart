// import 'dart:convert';

// import 'package:grocery_scanner/auth/secrets.dart';
// import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class Translator {
  static Future<TranslationResult> translate(String sourceText) async {
    final translation =
        await GoogleTranslator().translate(sourceText, to: "pl");
    return TranslationResult(
        text: translation.text,
        detectedSourceLang: translation.sourceLanguage.code);
  }

  // final DEEPL_API_URL = "https://api-free.deepl.com/v2/translate/";

  // Future<TranslateResult?> translate(String sourceText) async {
  //   final uri = Uri.parse(DEEPL_API_URL);
  //   // final response = await http.get(Uri.parse(uri));

  //   final response = await http.post(uri,
  //       headers: <String, String>{
  //         "Content-Type": "application/json",
  //         "Authorization": "DeepL-Auth-Key $deepL_apiKey"
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         "text": [sourceText],
  //         "target_lang": "PL"
  //       }));

  //   print(response.statusCode);

  //   if (response.statusCode == 200) {
  //     var decoded = json.decode(response.body);
  //     print(decoded);
  //     return TranslateResult.fromJson(decoded);
  //   } else {
  //     return null;
  //   }
  // }
}

class TranslationResult {
  final String text;
  final String detectedSourceLang;

  TranslationResult({required this.text, required this.detectedSourceLang});

  // factory TranslationResult.fromJson(Map<String, dynamic> json) {
  //   return TranslationResult(
  //       text: json["text"],
  //       detectedSourceLang: json["detected_source_language"]);
  // }
}
