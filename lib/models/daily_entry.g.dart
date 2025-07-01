// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyFoodEntryAdapter extends TypeAdapter<DailyFoodEntry> {
  @override
  final int typeId = 4;

  @override
  DailyFoodEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyFoodEntry(
      id: fields[0] as String,
      foodId: fields[1] as String,
      grams: fields[2] as double,
      timestamp: fields[3] as DateTime,
      mealId: fields[4] as String?,
      originalQuantity: fields[5] as double?,
      originalUnit: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyFoodEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.foodId)
      ..writeByte(2)
      ..write(obj.grams)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.mealId)
      ..writeByte(5)
      ..write(obj.originalQuantity)
      ..writeByte(6)
      ..write(obj.originalUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyFoodEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyMealEntryAdapter extends TypeAdapter<DailyMealEntry> {
  @override
  final int typeId = 5;

  @override
  DailyMealEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyMealEntry(
      id: fields[0] as String,
      mealId: fields[1] as String,
      multiplier: fields[2] as double,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyMealEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mealId)
      ..writeByte(2)
      ..write(obj.multiplier)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyMealEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
