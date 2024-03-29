// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:grocery_scanner/models/product.dart';
import 'package:http/http.dart' as http;

const PRODUCT_API_URL = "https://world.openfoodfacts.org/api/v2/product";

class OpenFoodFactsApiService {
  static Future<ProductResponse?> fetchProductByBarcode(String barcode) async {
    final uri = "$PRODUCT_API_URL/$barcode";
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      return ProductResponse.fromJson(decoded["product"]);
    } else {
      return null;
    }
  }
}
