// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Hijri.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HijriAdapter extends TypeAdapter<Hijri> {
  @override
  final int typeId = 12;

  @override
  Hijri read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hijri(
      date: fields[0] as String,
      format: fields[1] as String,
      day: fields[2] as String,
      weekday: fields[3] as HijriWeekday,
      month: fields[4] as HijriMonth,
      year: fields[5] as String,
      designation: fields[6] as Designation,
      holidays: (fields[7] as List)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Hijri obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.designation)
      ..writeByte(7)
      ..write(obj.holidays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HijriAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
