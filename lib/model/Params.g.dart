// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Params.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParamsAdapter extends TypeAdapter<Params> {
  @override
  final int typeId = 14;

  @override
  Params read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Params(
      fajr: fields[0] as int,
      isha: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Params obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.fajr)
      ..writeByte(1)
      ..write(obj.isha);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParamsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
