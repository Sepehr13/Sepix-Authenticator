// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Entity.type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntityAdapter extends TypeAdapter<Entity> {
  @override
  final int typeId = 0;

  @override
  Entity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Entity()
      ..title = fields[0] as String
      ..code = fields[1] as String
      ..type = fields[2] as String
      ..issuer = fields[3] as String
      ..count = fields[4] as int?
      ..lastHOTPCode = fields[5] == null ? '' : fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, Entity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.issuer)
      ..writeByte(4)
      ..write(obj.count)
      ..writeByte(5)
      ..write(obj.lastHOTPCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
