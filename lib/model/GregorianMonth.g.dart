// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GregorianMonth.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GregorianMonthAdapter extends TypeAdapter<GregorianMonth> {
  @override
  final int typeId = 8;

  @override
  GregorianMonth read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GregorianMonth(
      number: fields[0] as int,
      en: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GregorianMonth obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.en);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GregorianMonthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
