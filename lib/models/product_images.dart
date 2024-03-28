import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'product_images.g.dart';

class ProductImages {
  final String front;
  final String ingredients;
  final String nutrition;

  ProductImages({
    required this.front,
    required this.ingredients,
    required this.nutrition,
  });
}

@HiveType(typeId: 1)
class ProductOfflineImages {
  @HiveField(0)
  final Uint8List? front;

  @HiveField(1)
  final Uint8List? ingredients;

  @HiveField(2)
  final Uint8List? nutrition;

  ProductOfflineImages({
    required this.front,
    required this.ingredients,
    required this.nutrition,
  });
}
