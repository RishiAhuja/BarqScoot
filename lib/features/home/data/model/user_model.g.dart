// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      token: fields[1] as String,
      phoneNumber: fields[2] as String,
      firstName: fields[3] as String,
      lastName: fields[4] as String,
      dateOfBirth: fields[5] as DateTime,
      gender: fields[6] as String,
      isVerified: fields[7] as bool,
      email: fields[8] as String,
      location: fields[9] as String?,
      walletBalance: fields[10] as double,
      createdAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.dateOfBirth)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.isVerified)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.location)
      ..writeByte(10)
      ..write(obj.walletBalance)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
