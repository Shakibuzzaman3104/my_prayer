// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocalPrayer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalPrayerAdapter extends TypeAdapter<ModelLocalPrayer> {
  @override
  final int typeId = 18;

  @override
  ModelLocalPrayer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelLocalPrayer(
      id: fields[0] as int,
      name: fields[1] as String,
      time: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModelLocalPrayer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalPrayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
