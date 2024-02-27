import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/product_images.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

late Box<UserData> userLocalStorage;
late Box<ProductOffline> productLocalStorage;

Future saveUserLocally(UserData user) async {
  await userLocalStorage.clear();
  await userLocalStorage.put(0, user);
}

Future saveProductLocally(Object product) async {
  if (product is ProductOffline) {
    if (productLocalStorage.get(product.barcode) == null) {
      await productLocalStorage.put(product.barcode, product);
    }
  }

  if (product is Product) {
    http.Response? productImageFrontResponse;
    http.Response? productImageIngredientsResponse;
    http.Response? productImageNutrimentsResponse;

    try {
      productImageFrontResponse =
          await http.get(Uri.parse(product.images.front));
    } catch (e) {
      productImageFrontResponse = null;
    }

    try {
      productImageIngredientsResponse =
          await http.get(Uri.parse(product.images.ingredients));
    } catch (e) {
      productImageIngredientsResponse = null;
    }

    try {
      productImageNutrimentsResponse =
          await http.get(Uri.parse(product.images.nutrition));
    } catch (e) {
      productImageNutrimentsResponse = null;
    }

    var productOffline = ProductOffline(
      barcode: product.barcode,
      productName: product.productName,
      brand: product.brand,
      images: ProductOfflineImages(
        front: productImageFrontResponse?.bodyBytes,
        ingredients: productImageIngredientsResponse?.bodyBytes,
        nutrition: productImageNutrimentsResponse?.bodyBytes,
      ),
      ingredients: product.ingredients,
      nutriments: product.nutriments,
      allergens: product.allergens,
      nutriscore: product.nutriscore,
      tags: product.tags,
    );

    if (productLocalStorage.get(product.barcode) == null) {
      await productLocalStorage.put(product.barcode, productOffline);
    } else {
      int index = _getElementIndex(product);
      if (index != -1) {
        await productLocalStorage.putAt(index, productOffline);
      }
    }
  }
}

int _getElementIndex(Product product) {
  for (int i = 0; i < productLocalStorage.length; i++) {
    var value = productLocalStorage.getAt(i);
    if (value?.barcode == product.barcode) {
      return i;
    }
  }
  return -1;
}
