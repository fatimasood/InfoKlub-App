// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'career_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarrerModelAdapter extends TypeAdapter<CarrerModel> {
  @override
  final int typeId = 3;

  @override
  CarrerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarrerModel(
      jobTitle: fields[0] as String,
      companyName: fields[1] as String,
      startDate: fields[2] as String,
      endDate: fields[3] as String,
      skills: fields[4] as String,
      location: fields[5] as String,
      documentPaths: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CarrerModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.jobTitle)
      ..writeByte(1)
      ..write(obj.companyName)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.skills)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.documentPaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarrerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
