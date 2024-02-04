// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_nutriments.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductNutrimentsAdapter extends TypeAdapter<ProductNutriments> {
  @override
  final int typeId = 2;

  @override
  ProductNutriments read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductNutriments(
      energyKJ: (fields[0] as Map).cast<String, dynamic>(),
      energyKcal: (fields[1] as Map).cast<String, dynamic>(),
      fat: (fields[2] as Map).cast<String, dynamic>(),
      saturatedFat: (fields[3] as Map).cast<String, dynamic>(),
      carbohydrates: (fields[4] as Map).cast<String, dynamic>(),
      sugars: (fields[5] as Map).cast<String, dynamic>(),
      proteins: (fields[6] as Map).cast<String, dynamic>(),
      salt: (fields[7] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductNutriments obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.energyKJ)
      ..writeByte(1)
      ..write(obj.energyKcal)
      ..writeByte(2)
      ..write(obj.fat)
      ..writeByte(3)
      ..write(obj.saturatedFat)
      ..writeByte(4)
      ..write(obj.carbohydrates)
      ..writeByte(5)
      ..write(obj.sugars)
      ..writeByte(6)
      ..write(obj.proteins)
      ..writeByte(7)
      ..write(obj.salt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductNutrimentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
