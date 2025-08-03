// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CouponAdapter extends TypeAdapter<Coupon> {
  @override
  final int typeId = 47;

  @override
  Coupon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coupon(
      id: fields[0] as String,
      createdAt: fields[1] as DateTime?,
      title: fields[2] as String,
      description: fields[3] as String?,
      oldPrice: fields[4] as double?,
      newPrice: fields[5] as double?,
      discount: fields[13] as String?,
      images: (fields[6] as List?)?.cast<String>(),
      provider: fields[7] as String,
      website: fields[8] as String?,
      location: fields[9] as String?,
      category: fields[10] as String,
      qrCode: fields[11] as String?,
      expiresAt: fields[12] as DateTime?,
      availableCoupons: fields[14] as int?,
      voteCount: fields[15] as int?,
      hiddenQrCode: fields[16] as String?,
      couponUsesCounter: fields[17] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Coupon obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.oldPrice)
      ..writeByte(5)
      ..write(obj.newPrice)
      ..writeByte(6)
      ..write(obj.images)
      ..writeByte(7)
      ..write(obj.provider)
      ..writeByte(8)
      ..write(obj.website)
      ..writeByte(9)
      ..write(obj.location)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.qrCode)
      ..writeByte(12)
      ..write(obj.expiresAt)
      ..writeByte(13)
      ..write(obj.discount)
      ..writeByte(14)
      ..write(obj.availableCoupons)
      ..writeByte(15)
      ..write(obj.voteCount)
      ..writeByte(16)
      ..write(obj.hiddenQrCode)
      ..writeByte(17)
      ..write(obj.couponUsesCounter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouponAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
