// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsEntityAdapter extends TypeAdapter<NewsEntity> {
  @override
  final int typeId = 0;

  @override
  NewsEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsEntity(
      title: fields[0] as String,
      description: fields[1] as String,
      pubDate: fields[2] as DateTime,
      imageUrl: fields[3] as String,
      url: fields[4] as String,
      content: fields[5] as String,
      author: fields[6] as int,
      categoryIds: (fields[7] as List).cast<int>(),
      copyright: (fields[8] as List).cast<String>(),
      videoUrl: fields[9] as String?,
      pinned: fields[10] == null ? false : fields[10] as bool,
      webViewUrl: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NewsEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.pubDate)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.author)
      ..writeByte(7)
      ..write(obj.categoryIds)
      ..writeByte(8)
      ..write(obj.copyright)
      ..writeByte(9)
      ..write(obj.videoUrl)
      ..writeByte(10)
      ..write(obj.pinned)
      ..writeByte(11)
      ..write(obj.webViewUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
