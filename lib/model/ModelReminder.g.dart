// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ModelReminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelReminderAdapter extends TypeAdapter<ModelReminder> {
  @override
  final int typeId = 20;

  @override
  ModelReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelReminder(
      id: fields[0] as int,
      name: fields[1] as String,
      dateTime: fields[2] as String,
      status: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ModelReminder obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
