// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatusAdapter extends TypeAdapter<UserStatus> {
  @override
  final int typeId = 10;

  @override
  UserStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStatus(
      userHash: fields[0] as String,
      hasTrialStarted: fields[1] as bool,
      trialStartDate: fields[2] as DateTime?,
      trialEndDate: fields[3] as DateTime?,
      hasPurchased: fields[4] as bool,
      purchaseToken: fields[5] as String?,
      purchaseDate: fields[6] as DateTime?,
      lastUpdated: fields[7] as DateTime,
      isPromoUser: fields[8] as bool,
      promoCode: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserStatus obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userHash)
      ..writeByte(1)
      ..write(obj.hasTrialStarted)
      ..writeByte(2)
      ..write(obj.trialStartDate)
      ..writeByte(3)
      ..write(obj.trialEndDate)
      ..writeByte(4)
      ..write(obj.hasPurchased)
      ..writeByte(5)
      ..write(obj.purchaseToken)
      ..writeByte(6)
      ..write(obj.purchaseDate)
      ..writeByte(7)
      ..write(obj.lastUpdated)
      ..writeByte(8)
      ..write(obj.isPromoUser)
      ..writeByte(9)
      ..write(obj.promoCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
