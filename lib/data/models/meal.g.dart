// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealIngredientAdapter extends TypeAdapter<MealIngredient> {
  @override
  final int typeId = 1;

  @override
  MealIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealIngredient(
      foodId: fields[0] as String,
      grams: fields[1] as double,
      originalQuantity: fields[2] as double?,
      originalUnit: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MealIngredient obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.foodId)
      ..writeByte(1)
      ..write(obj.grams)
      ..writeByte(2)
      ..write(obj.originalQuantity)
      ..writeByte(3)
      ..write(obj.originalUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealIngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 2;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      ingredients: (fields[3] as List).cast<MealIngredient>(),
      createdAt: fields[4] as DateTime,
      lastUsed: fields[5] as DateTime,
      useCount: fields[6] as int,
      category: fields[7] as String?,
      isFavorite: fields[8] as bool,
      imagePath: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.ingredients)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastUsed)
      ..writeByte(6)
      ..write(obj.useCount)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.isFavorite)
      ..writeByte(9)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
