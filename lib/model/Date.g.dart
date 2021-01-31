// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Date.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DateAdapter extends TypeAdapter<Date> {
  @override
  final int typeId = 4;

  @override
  Date read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Date(
      readable: fields[0] as String,
      timestamp: fields[1] as String,
      gregorian: fields[2] as Gregorian,
      hijri: fields[3] as Hijri,
    );
  }

  @override
  void write(BinaryWriter writer, Date obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.readable)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.gregorian)
      ..writeByte(3)
      ..write(obj.hijri);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
