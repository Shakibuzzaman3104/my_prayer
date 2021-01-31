// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HijriWeekday.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HijriWeekdayAdapter extends TypeAdapter<HijriWeekday> {
  @override
  final int typeId = 10;

  @override
  HijriWeekday read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HijriWeekday(
      en: fields[0] as String,
      ar: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HijriWeekday obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.en)
      ..writeByte(1)
      ..write(obj.ar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HijriWeekdayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
