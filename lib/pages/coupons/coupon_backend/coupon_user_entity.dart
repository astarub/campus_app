import 'package:hive/hive.dart';
part 'coupon_user_entity.g.dart'; // Für Hive-Adapter-Generierung

@HiveType(typeId: 59)
class CouponUser {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final List<String>? favoriteCoupons;
  @HiveField(2)
  final List<String>? likedCoupons;
  @HiveField(3)
  final List<String>? dislikedCoupons;
  @HiveField(4)
  final List<String>? userMaxCoupons;

  CouponUser({
    required this.userId,
    this.favoriteCoupons,
    this.likedCoupons,
    this.dislikedCoupons,
    this.userMaxCoupons,
  });

  factory CouponUser.fromMap(Map<String, dynamic> map) {
    List<String> safeList(dynamic rawList) {
      if (rawList == null) return [];
      try {
        return List<String>.from(
          (rawList as List).map((e) => e?.toString() ?? ''),
        );
      } catch (e) {
        return [];
      }
    }

    return CouponUser(
      userId: map[r'$id']?.toString() ?? '',
      favoriteCoupons: safeList(map['favoriteCoupons']),
      likedCoupons: safeList(map['likedCoupons']),
      dislikedCoupons: safeList(map['dislikedCoupons']),
      userMaxCoupons: safeList(map['userMaxCoupons']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'favoriteCoupons': favoriteCoupons,
      'likedCoupons': likedCoupons,
      'dislikedCoupons': dislikedCoupons,
      'userMaxCoupons': userMaxCoupons,
    };
  }
}
