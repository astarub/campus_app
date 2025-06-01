// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_user_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CouponUserAdapter extends TypeAdapter<CouponUser> {
  @override
  final int typeId = 59;

  @override
  CouponUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CouponUser(
      userId: fields[0] as String,
      favoriteCoupons: (fields[1] as List?)?.cast<String>(),
      likedCoupons: (fields[2] as List?)?.cast<String>(),
      dislikedCoupons: (fields[3] as List?)?.cast<String>(),
      userMaxCoupons: (fields[4] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CouponUser obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.favoriteCoupons)
      ..writeByte(2)
      ..write(obj.likedCoupons)
      ..writeByte(3)
      ..write(obj.dislikedCoupons)
      ..writeByte(4)
      ..write(obj.userMaxCoupons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouponUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
