import 'dart:async';
import 'package:appwrite/models.dart' as models;
import 'package:campus_app/pages/coupons/coupon_backend/coupon_user_entity.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:hive/hive.dart';
import 'package:campus_app/pages/coupons/coupon_backend/coupon_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Hive-Box für Coupons (optional zwischengespeichert)
Box<Coupon>? _couponBox;
// Hive-Box für CouponUser (optional zwischengespeichert)
Box<CouponUser>? _couponUserBox;

class CouponUserBackendRepository {
  final Client client;
  static const _deviceIdKey = 'persistent_device_id';

  CouponUserBackendRepository({
    required this.client,
  });

  // Lazy Initialisierung und Zugriff auf die Coupon-Box
  Future<Box<Coupon>> get _couponBoxAsync async {
    try {
      _couponBox ??= await Hive.openBox<Coupon>('couponBox');
      return _couponBox!;
    } catch (e) {
      debugPrint('Fehler beim Öffnen der CouponBox: $e');
      rethrow;
    }
  }

  // Lazy Initialisierung und Zugriff auf die CouponUser-Box
  Future<Box<CouponUser>> get _couponUserBoxAsync async {
    try {
      _couponUserBox ??= await Hive.openBox<CouponUser>('couponUserBox');
      return _couponUserBox!;
    } catch (e) {
      debugPrint('Fehler beim Öffnen der CouponUserBox: $e');
      rethrow;
    }
  }

  Future<String> getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedId = prefs.getString(_deviceIdKey);

    if (storedId != null && storedId.isNotEmpty) {
      return storedId;
    }
    final newId = ID.unique(); // Already Appwrite-compatible

    await prefs.setString(_deviceIdKey, newId);
    return newId;
  }

  Future<models.Document> createUserCoupon(CouponUser coupon, String userId) async {
    final Databases databaseService = Databases(client);

    final data = {
      'favoriteCoupons': coupon.favoriteCoupons ?? [],
      'likedCoupons': coupon.likedCoupons ?? [],
      'dislikedCoupons': coupon.dislikedCoupons ?? [],
      'userMaxCoupons': coupon.userMaxCoupons ?? [],
    };

    final document = await databaseService.createDocument(
      databaseId: 'coupon',
      collectionId: 'UserCoupon',
      documentId: userId,
      data: data,
    );
    return document;
  }

  // Fetch a user's coupon interactions
  Future<CouponUser> getUserCoupons(String userId) async {
    final Databases databaseService = Databases(client);

    try {
      final document = await databaseService.getDocument(
        databaseId: 'coupon',
        collectionId: 'UserCoupon',
        documentId: userId,
      );

      return CouponUser.fromMap(document.data);
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        // Document not found
        // Create new document if it doesn't exist
        final newUser = CouponUser(
          userId: userId,
          favoriteCoupons: [],
          likedCoupons: [],
          dislikedCoupons: [],
          userMaxCoupons: [],
        );
        await createUserCoupon(newUser, userId);
        return newUser;
      } else {
        rethrow;
      }
    }
  }

  // Update user's coupon interactions
  Future<models.Document> updateUserCoupons({
    required Map<String, dynamic> updatedFields,
  }) async {
    final Databases databaseService = Databases(client);
    final userId = await getOrCreateDeviceId();

    try {
      // Test, ob Dokument existiert
      await databaseService.getDocument(
        databaseId: 'coupon',
        collectionId: 'UserCoupon',
        documentId: userId,
      );
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        // Dokument existiert nicht → erstelle es
        final newUser = CouponUser(
          userId: userId,
          favoriteCoupons: [],
          likedCoupons: [],
          dislikedCoupons: [],
          userMaxCoupons: [],
        );
        await createUserCoupon(newUser, userId);
      } else {
        rethrow;
      }
    }

    // Now safely attempt to update
    try {
      final updatedDocument = await databaseService.updateDocument(
        databaseId: 'coupon',
        collectionId: 'UserCoupon',
        documentId: userId,
        data: updatedFields,
      );
      return updatedDocument;
    } catch (e) {
      debugPrint("Fehler beim Update von UserCoupons: $e");
      rethrow;
    }
  }

  ///Speichert eine Liste von Coupons lokal in Hive (z. B. für Offline-Verfügbarkeit).
  Future<void> cacheUserCouponsLocally(List<Coupon> coupons) async {
    try {
      final box = await _couponBoxAsync;
      await box.clear(); // optional: zuerst alte löschen

      for (final coupon in coupons) {
        await box.put(coupon.id, coupon);
      }
    } catch (e) {
      debugPrint('Fehler beim lokalen Speichern der Coupons: $e');
    }
  }

  /// Speichert einen einzelnen Coupon lokal in Hive anhand seiner ID.
  Future<void> saveCouponToHive(Coupon coupon) async {
    try {
      final box = await _couponBoxAsync;
      await box.put(coupon.id, coupon);
    } catch (e) {
      debugPrint('Fehler beim Speichern eines Coupons: $e');
    }
  }

  /// Lädt einen bestimmten Coupon aus Hive anhand der ID.
  /// Gibt null zurück, wenn kein Eintrag vorhanden ist.
  Future<Coupon?> loadCouponFromHive(String couponId) async {
    try {
      final box = await _couponBoxAsync;
      return box.get(couponId);
    } catch (e) {
      debugPrint('Fehler beim Laden eines Coupons: $e');
      return null;
    }
  }

// Lädt alle Coupons aus Hive und gibt sie als Liste zurück.
  Future<List<Coupon>> loadAllCouponsFromHive() async {
    try {
      final box = await _couponBoxAsync;
      return box.values.toList();
    } catch (e) {
      debugPrint('Fehler beim Laden aller Coupons: $e');
      return [];
    }
  }

  /// Speichert CouponUser lokal in Hive anhand der userId.
  Future<void> saveCouponUserToHive(CouponUser user) async {
    try {
      final box = await _couponUserBoxAsync;
      await box.put(user.userId, user);
    } catch (e) {
      debugPrint('Fehler beim Speichern des CouponUser: $e');
    }
  }

// Lädt einen bestimmten CouponUser aus Hive anhand der userId.
  /// Gibt null zurück, wenn kein entsprechender Eintrag vorhanden ist.
  Future<CouponUser?> loadCouponUserFromHive(String userId) async {
    try {
      final box = await _couponUserBoxAsync;
      return box.get(userId);
    } catch (e) {
      debugPrint('Fehler beim Laden  des CouponUser: $e');
      return null;
    }
  }

  /// Lädt alle CouponUser-Objekte aus Hive als Liste.
  /// Gibt eine leere Liste zurück, wenn keine vorhanden oder Fehler auftreten.
  Future<List<CouponUser>> loadAllCouponUsersFromHive() async {
    try {
      final box = await _couponUserBoxAsync;
      return box.values.toList();
    } catch (e) {
      debugPrint('Fehler beim Laden aller CouponUser: $e');
      return [];
    }
  }
}
