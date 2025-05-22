import 'dart:async';
import 'package:appwrite/models.dart' as models;
import 'package:campus_app/pages/coupons/coupon_backend/coupon_user_entity.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

class CouponUserBackendRepository {
  final Client client;
  bool authenticated = false;

  CouponUserBackendRepository({
    required this.client,
  });

  Future<models.Document> createUserCoupon(CouponUser coupon) async {
    final Databases databaseService = Databases(client);

    final data = {
      'userId': coupon.userId,
      'favoriteCoupons': coupon.favoriteCoupons ?? [],
      'likedCoupons': coupon.likedCoupons ?? [],
      'dislikedCoupons': coupon.dislikedCoupons ?? [],
      'userMaxCoupons': coupon.userMaxCoupons ?? [],
    };
    try {
      final document = await databaseService.createDocument(
        databaseId: '681a0e830016ba0cf88d',
        collectionId: '68225527003712c670e4',
        documentId: ID.unique(),
        data: data,
      );
      return document;
    } on AppwriteException catch (e) {
      debugPrint('Error while creating user coupon: ${e.message}');
      rethrow;
    }
  }

  // Fetch a user's coupon interactions
  Future<CouponUser> getUserCoupons(String userId) async {
    final Databases databaseService = Databases(client);

    try {
      final document = await databaseService.getDocument(
        databaseId: '681a0e830016ba0cf88d',
        collectionId: '68225527003712c670e4',
        documentId: userId,
      );
      return CouponUser.fromMap(document.data);
    } on AppwriteException catch (e) {
      debugPrint('Error while fetching user coupon: ${e.message}');
      rethrow;
    }
  }

  // Update user's coupon interactions
  Future<models.Document> updateUserCoupons({
    required String userId,
    required Map<String, dynamic> updatedFields,
  }) async {
    final Databases databaseService = Databases(client);

    try {
      final updatedDocument = await databaseService.updateDocument(
        databaseId: '681a0e830016ba0cf88d',
        collectionId: '68225527003712c670e4',
        documentId: userId,
        data: updatedFields,
      );
      return updatedDocument;
    } on AppwriteException catch (e) {
      debugPrint('Error while updating user coupon: ${e.message}');
      rethrow;
    }
  }
}
