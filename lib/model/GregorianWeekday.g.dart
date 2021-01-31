// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GregorianWeekday.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GregorianWeekdayAdapter extends TypeAdapter<GregorianWeekday> {
  @override
  final int typeId = 6;

  @override
  GregorianWeekday read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GregorianWeekday(
      en: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GregorianWeekday obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.en);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GregorianWeekdayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
