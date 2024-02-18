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
  final List<int>? front;

  @HiveField(1)
  final List<int>? ingredients;

  @HiveField(2)
  final List<int>? nutrition;

  ProductOfflineImages({
    required this.front,
    required this.ingredients,
    required this.nutrition,
  });
}
