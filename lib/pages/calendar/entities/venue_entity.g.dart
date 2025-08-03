// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VenueAdapter extends TypeAdapter<Venue> {
  @override
  final int typeId = 53;

  @override
  Venue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Venue(
      id: fields[0] as int,
      url: fields[1] as String,
      name: fields[2] as String,
      slug: fields[3] as String,
      address: fields[4] as String?,
      city: fields[5] as String?,
      country: fields[6] as String?,
      province: fields[7] as String?,
      zip: fields[8] as String?,
      phone: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Venue obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.slug)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.country)
      ..writeByte(7)
      ..write(obj.province)
      ..writeByte(8)
      ..write(obj.zip)
      ..writeByte(9)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
