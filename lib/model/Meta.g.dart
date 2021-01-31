// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MetaAdapter extends TypeAdapter<Meta> {
  @override
  final int typeId = 16;

  @override
  Meta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meta(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      timezone: fields[2] as String,
      method: fields[3] as Method,
      latitudeAdjustmentMethod: fields[4] as String,
      midnightMode: fields[5] as String,
      school: fields[6] as String,
      offset: (fields[7] as Map)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Meta obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.timezone)
      ..writeByte(3)
      ..write(obj.method)
      ..writeByte(4)
      ..write(obj.latitudeAdjustmentMethod)
      ..writeByte(5)
      ..write(obj.midnightMode)
      ..writeByte(6)
      ..write(obj.school)
      ..writeByte(7)
      ..write(obj.offset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
