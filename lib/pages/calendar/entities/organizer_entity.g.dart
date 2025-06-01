// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizerAdapter extends TypeAdapter<Organizer> {
  @override
  final int typeId = 42;

  @override
  Organizer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Organizer(
      id: fields[0] as int,
      url: fields[1] as String,
      name: fields[2] as String,
      slug: fields[3] as String,
      phone: fields[4] as String?,
      website: fields[5] as String?,
      email: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Organizer obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.slug)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.website)
      ..writeByte(6)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
