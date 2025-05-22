class CouponUser {
  final String userId;
  List<String>? favoriteCoupons;
  List<String>? likedCoupons;
  List<String>? dislikedCoupons;
  List<String>? userMaxCoupons;

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
      userId: map['userId']?.toString() ?? map[r'$id']?.toString() ?? '6822fb140013c217724f',
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
