// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthModelAdapter extends TypeAdapter<HealthModel> {
  @override
  final int typeId = 1;

  @override
  HealthModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthModel(
      bloodType: fields[0] as String,
      medications: (fields[1] as List).cast<String>(),
      documentPaths: (fields[2] as List).cast<String>(),
      allergies: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HealthModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.bloodType)
      ..writeByte(1)
      ..write(obj.medications)
      ..writeByte(2)
      ..write(obj.documentPaths)
      ..writeByte(3)
      ..write(obj.allergies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
