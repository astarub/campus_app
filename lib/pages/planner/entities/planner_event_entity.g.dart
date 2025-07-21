// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_event_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlannerEventEntityAdapter extends TypeAdapter<PlannerEventEntity> {
  @override
  final int typeId = 6;

  @override
  PlannerEventEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlannerEventEntity(
      id: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String?,
      startDateTime: fields[3] as DateTime,
      endDateTime: fields[4] as DateTime,
      colorValue: fields[5] as int?,
      rrule: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlannerEventEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startDateTime)
      ..writeByte(4)
      ..write(obj.endDateTime)
      ..writeByte(5)
      ..write(obj.colorValue)
      ..writeByte(6)
      ..write(obj.rrule);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlannerEventEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
