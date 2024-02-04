// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductOfflineAdapter extends TypeAdapter<ProductOffline> {
  @override
  final int typeId = 0;

  @override
  ProductOffline read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductOffline(
      barcode: fields[0] as String,
      productName: fields[1] as String,
      brand: fields[2] as String,
      images: fields[3] as ProductOfflineImages,
      ingredients: fields[4] as String,
      nutriments: fields[5] as ProductNutriments,
      allergens: (fields[6] as List).toSet(),
      nutriscore: fields[7] as String,
      tags: (fields[8] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductOffline obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.barcode)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.images)
      ..writeByte(4)
      ..write(obj.ingredients)
      ..writeByte(5)
      ..write(obj.nutriments)
      ..writeByte(6)
      ..write(obj.allergens.toList())
      ..writeByte(7)
      ..write(obj.nutriscore)
      ..writeByte(8)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductOfflineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
