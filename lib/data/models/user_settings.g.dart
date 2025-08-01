// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 3;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      dailyCalorieTarget: fields[0] as double?,
      createdAt: fields[1] as DateTime,
      lastUpdated: fields[2] as DateTime,
      weight: fields[3] as double?,
      height: fields[4] as double?,
      age: fields[5] as int?,
      gender: fields[6] as String?,
      activityLevel: fields[7] as String?,
      neck: fields[8] as double?,
      waist: fields[9] as double?,
      hip: fields[10] as double?,
      darkMode: fields[11] as bool,
      notifications: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.dailyCalorieTarget)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.lastUpdated)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.age)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.activityLevel)
      ..writeByte(8)
      ..write(obj.neck)
      ..writeByte(9)
      ..write(obj.waist)
      ..writeByte(10)
      ..write(obj.hip)
      ..writeByte(11)
      ..write(obj.darkMode)
      ..writeByte(12)
      ..write(obj.notifications);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
