import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/product_images.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

// Product
late Box<ProductOffline> productLocalStorage;

Future saveProductLocally(Object product) async {
  if (product is ProductOffline) {
    if (productLocalStorage.get(product.barcode) == null) {
      await productLocalStorage.put(product.barcode, product);
    }
  }

  if (product is Product) {
    if (productLocalStorage.get(product.barcode) == null) {
      // final productImageFrontResponse =
      //     await http.get(Uri.parse(product.images.front));
      // final productImageIngredientsResponse =
      //     await http.get(Uri.parse(product.images.ingredients));
      // final productImageNutrimentsResponse =
      //     await http.get(Uri.parse(product.images.nutrition));

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

      await productLocalStorage.put(product.barcode, productOffline);
    }
  }
}
