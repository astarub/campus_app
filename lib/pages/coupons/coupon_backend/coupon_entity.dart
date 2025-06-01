// ignore_for_file: avoid_dynamic_calls

import 'package:hive/hive.dart';
part 'coupon_entity.g.dart'; // Für Hive-Adapter-Generierung

@HiveType(typeId: 47)
class Coupon {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime? createdAt;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final double? oldPrice;
  @HiveField(5)
  final double? newPrice;
  @HiveField(6)
  final List<String>? images;
  @HiveField(7)
  final String provider;
  @HiveField(8)
  final String? website;
  @HiveField(9)
  final String? location;
  @HiveField(10)
  final String category;
  @HiveField(11)
  final String? qrCode;
  @HiveField(12)
  final DateTime? expiresAt;
  @HiveField(13)
  final String? discount;
  @HiveField(14)
  final int? availableCoupons;
  @HiveField(15)
  final int? voteCount;
  @HiveField(16)
  final String? hiddenQrCode;
  @HiveField(17)
  final int? couponUsesCounter;

  Coupon({
    required this.id,
    this.createdAt,
    required this.title,
    required this.description,
    this.oldPrice,
    this.newPrice,
    this.discount,
    this.images,
    required this.provider,
    this.website,
    this.location,
    required this.category,
    this.qrCode,
    this.expiresAt,
    this.availableCoupons,
    this.voteCount = 0,
    this.hiddenQrCode,
    this.couponUsesCounter = 0,
  });

  factory Coupon.fromMap(Map<String, dynamic> map) {
    List<String>? processedImages;
    if (map['images'] != null) {
      processedImages = (map['images'] as List)
          .where((image) => image != null && image.toString().isNotEmpty)
          .map((image) => image.toString())
          .toList();
      processedImages = processedImages.isEmpty ? null : processedImages.toSet().toList();
    }

    return Coupon(
      id: map[r'$id'],
      createdAt: map[r'$createdAt'] != null ? DateTime.tryParse(map[r'$createdAt']) : null,
      title: (map['title'] == null || map['title'].trim().isEmpty) ? 'Kein Titel' : map['title'],
      description: (map['description'] == null || map['description'].trim().isEmpty)
          ? 'Keine Details vorhanden.'
          : map['description'],
      oldPrice: (map['oldPrice'] as num?)?.toDouble(),
      newPrice: (map['newPrice'] as num?)?.toDouble(),
      discount: (map['discount']?.toString().trim().isEmpty ?? true) ? null : map['discount'],
      images: processedImages,
      provider: (map['provider'] == null || map['provider'].trim().isEmpty) ? 'Anbieter unbekannt' : map['provider'],
      website: map['website'],
      location: map['location'],
      category: map['category'],
      qrCode: map['qrCode'] ?? '',
      expiresAt: map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
      availableCoupons: map['availableCoupons'],
      voteCount: map['voteCount'],
      hiddenQrCode: map['hiddenQrCode'],
      couponUsesCounter: map['couponUsesCounter'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'oldPrice': oldPrice,
      'newPrice': newPrice,
      'discount': discount,
      'images': images,
      'provider': provider,
      'website': website,
      'location': location,
      'category': category,
      'qrCode': qrCode,
      'expiresAt': expiresAt?.toIso8601String(),
      'availableCoupons': availableCoupons,
      'voteCount': voteCount,
      'hiddenQrCode': hiddenQrCode,
      'couponUsesCounter': couponUsesCounter,
    };
  }
}
