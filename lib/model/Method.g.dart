// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Method.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MethodAdapter extends TypeAdapter<Method> {
  @override
  final int typeId = 13;

  @override
  Method read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Method(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Method obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
