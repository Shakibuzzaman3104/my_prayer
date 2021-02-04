// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ModelTasbih.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelTasbihAdapter extends TypeAdapter<ModelTasbih> {
  @override
  final int typeId = 21;

  @override
  ModelTasbih read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelTasbih(
      counter: fields[0] as double,
      title: fields[1] as String,
      recitation: fields[2] as String,
      max: fields[3] as double,
    )..index = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, ModelTasbih obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.counter)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.recitation)
      ..writeByte(3)
      ..write(obj.max)
      ..writeByte(4)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelTasbihAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
