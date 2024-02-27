// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 3;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      emailAddress: fields[0] as String,
      displayName: fields[1] as String,
      preferences: (fields[2] as List).cast<dynamic>(),
      restrictions: (fields[3] as List).cast<dynamic>(),
      yourProducts: (fields[4] as List).cast<dynamic>(),
      recentlyScannedProducts: (fields[5] as List).cast<dynamic>(),
      pinnedProducts: (fields[6] as List).cast<dynamic>(),
      createdAtTimestamp: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.emailAddress)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.preferences)
      ..writeByte(3)
      ..write(obj.restrictions)
      ..writeByte(4)
      ..write(obj.yourProducts)
      ..writeByte(5)
      ..write(obj.recentlyScannedProducts)
      ..writeByte(6)
      ..write(obj.pinnedProducts)
      ..writeByte(7)
      ..write(obj.createdAtTimestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
