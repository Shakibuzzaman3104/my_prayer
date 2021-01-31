// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ModelPrayer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelPrayerAdapter extends TypeAdapter<ModelPrayer> {
  @override
  final int typeId = 1;

  @override
  ModelPrayer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelPrayer(
      code: fields[0] as int,
      status: fields[1] as String,
      data: (fields[2] as List)?.cast<Datum>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModelPrayer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelPrayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
