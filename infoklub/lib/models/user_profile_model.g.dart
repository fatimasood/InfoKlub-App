// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 0;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      name: fields[8] as String,
      email: fields[0] as String,
      phone: fields[1] as String,
      dob: fields[2] as String,
      city: fields[3] as String,
      bio: fields[4] as String,
      profileImagePath: fields[5] as String,
      flag: fields[6] as String,
      dialCode: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.dob)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.profileImagePath)
      ..writeByte(6)
      ..write(obj.flag)
      ..writeByte(7)
      ..write(obj.dialCode)
      ..writeByte(8)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
