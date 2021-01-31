// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Gregorian.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GregorianAdapter extends TypeAdapter<Gregorian> {
  @override
  final int typeId = 5;

  @override
  Gregorian read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gregorian(
      date: fields[0] as String,
      format: fields[1] as String,
      day: fields[2] as String,
      weekday: fields[3] as GregorianWeekday,
      month: fields[4] as GregorianMonth,
      year: fields[5] as String,
      designation: fields[6] as Designation,
    );
  }

  @override
  void write(BinaryWriter writer, Gregorian obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.format)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.weekday)
      ..writeByte(4)
      ..write(obj.month)
      ..writeByte(5)
      ..write(obj.year)
      ..writeByte(6)
      ..write(obj.designation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GregorianAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
