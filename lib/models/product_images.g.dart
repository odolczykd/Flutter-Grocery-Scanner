// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_images.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductOfflineImagesAdapter extends TypeAdapter<ProductOfflineImages> {
  @override
  final int typeId = 1;

  @override
  ProductOfflineImages read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductOfflineImages(
      front: fields[0] as Uint8List?,
      ingredients: fields[1] as Uint8List?,
      nutrition: fields[2] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductOfflineImages obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.front)
      ..writeByte(1)
      ..write(obj.ingredients)
      ..writeByte(2)
      ..write(obj.nutrition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductOfflineImagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
