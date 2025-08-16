// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderModelAdapter extends TypeAdapter<ReminderModel> {
  @override
  final int typeId = 4;

  @override
  ReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderModel(
      id: fields[0] as String,
      title: fields[1] as String,
      notes: fields[2] as String?,
      dateUtcMs: fields[3] as int?,
      timeMinutes: fields[4] as int?,
      isCompleted: fields[5] as bool,
      colorValue: fields[6] as int?,
      repeatDays: (fields[7] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReminderModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.dateUtcMs)
      ..writeByte(4)
      ..write(obj.timeMinutes)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.colorValue)
      ..writeByte(7)
      ..write(obj.repeatDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
