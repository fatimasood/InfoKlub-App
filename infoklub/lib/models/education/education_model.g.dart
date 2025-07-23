// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EducationInfoAdapter extends TypeAdapter<EducationInfo> {
  @override
  final int typeId = 2;

  @override
  EducationInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EducationInfo(
      degree: fields[0] as String,
      institution: fields[1] as String,
      totalGrade: fields[2] as String,
      scoreGrade: fields[3] as String,
      percentage: fields[4] as String,
      achievements: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EducationInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.degree)
      ..writeByte(1)
      ..write(obj.institution)
      ..writeByte(2)
      ..write(obj.totalGrade)
      ..writeByte(3)
      ..write(obj.scoreGrade)
      ..writeByte(4)
      ..write(obj.percentage)
      ..writeByte(5)
      ..write(obj.achievements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
