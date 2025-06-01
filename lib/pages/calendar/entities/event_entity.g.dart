// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 78;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as int,
      url: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      slug: fields[4] as String,
      hasImage: fields[5] as bool,
      imageUrl: fields[6] as String?,
      startDate: fields[7] as DateTime,
      endDate: fields[8] as DateTime,
      allDay: fields[9] as bool,
      cost: (fields[10] as Map?)?.cast<String, String>(),
      website: fields[11] as String?,
      categories: (fields[12] as List).cast<Category>(),
      venue: fields[13] as Venue,
      organizers: (fields[14] as List).cast<Organizer>(),
      author: fields[15] as String,
      pinned: fields[16] == null ? false : fields[16] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.slug)
      ..writeByte(5)
      ..write(obj.hasImage)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.endDate)
      ..writeByte(9)
      ..write(obj.allDay)
      ..writeByte(10)
      ..write(obj.cost)
      ..writeByte(11)
      ..write(obj.website)
      ..writeByte(12)
      ..write(obj.categories)
      ..writeByte(13)
      ..write(obj.venue)
      ..writeByte(14)
      ..write(obj.organizers)
      ..writeByte(15)
      ..write(obj.author)
      ..writeByte(16)
      ..write(obj.pinned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
