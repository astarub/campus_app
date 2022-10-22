// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DishEntityAdapter extends TypeAdapter<DishEntity> {
  @override
  final int typeId = 5;

  @override
  DishEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DishEntity(
      date: fields[0] as int,
      category: fields[1] as String,
      title: fields[2] as String,
      price: fields[3] as String,
      infos: (fields[4] as List).cast<String>(),
      allergenes: (fields[5] as List).cast<String>(),
      additives: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DishEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.infos)
      ..writeByte(5)
      ..write(obj.allergenes)
      ..writeByte(6)
      ..write(obj.additives);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
