// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ModelLocalPrayerParent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelLocalPrayerParentAdapter
    extends TypeAdapter<ModelLocalPrayerParent> {
  @override
  final int typeId = 19;

  @override
  ModelLocalPrayerParent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelLocalPrayerParent(
      date: fields[0] as String,
      prayers: (fields[1] as HiveList)?.castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, ModelLocalPrayerParent obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.prayers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelLocalPrayerParentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
