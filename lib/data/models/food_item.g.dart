// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodItemAdapter extends TypeAdapter<FoodItem> {
  @override
  final int typeId = 0;

  @override
  FoodItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodItem(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      calories: fields[3] as double,
      protein: fields[4] as double,
      carbs: fields[5] as double,
      fat: fields[6] as double,
      unit: fields[7] as String,
      unitWeight: fields[8] as double?,
      servingDescription: fields[9] as String?,
      customMacros: (fields[10] as Map?)?.cast<String, double>(),
      createdAt: fields[11] as DateTime,
      lastUsed: fields[12] as DateTime,
      useCount: fields[13] as int,
      imagePath: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FoodItem obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.calories)
      ..writeByte(4)
      ..write(obj.protein)
      ..writeByte(5)
      ..write(obj.carbs)
      ..writeByte(6)
      ..write(obj.fat)
      ..writeByte(7)
      ..write(obj.unit)
      ..writeByte(8)
      ..write(obj.unitWeight)
      ..writeByte(9)
      ..write(obj.servingDescription)
      ..writeByte(10)
      ..write(obj.customMacros)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.lastUsed)
      ..writeByte(13)
      ..write(obj.useCount)
      ..writeByte(14)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
