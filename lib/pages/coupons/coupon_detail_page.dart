// ignore_for_file: deprecated_member_use

import 'dart:io' show Platform;
import 'package:campus_app/pages/coupons/coupon_backend/coupon_entity.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/coupons/coupon_backend/coupon_user_backend_repository.dart';
import 'package:campus_app/pages/coupons/coupon_backend/coupon_user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:campus_app/core/themes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:campus_app/pages/coupons/full_screen_image.dart';

class CouponDetailPage extends StatefulWidget {
  final Map<String, dynamic> deal;

  const CouponDetailPage({
    super.key,
    required this.deal,
  });

  @override
  State<CouponDetailPage> createState() => _CouponDetailPageState();
}

class _CouponDetailPageState extends State<CouponDetailPage> {
  Future openLink(BuildContext context, String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  /// Zeigt ein BottomSheet, das einen QR-Code enthält (snapping sheet).
  /// Unter dem QR-Code kann ggf. noch der Link stehen.
  void showQrCodeBottomSheet(BuildContext context, String qrCode, {String? website, String? location}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final isDarkMode = Provider.of<ThemesNotifier>(context).currentThemeData.brightness == Brightness.dark;
        return DraggableScrollableSheet(
          minChildSize: 0.50,
          maxChildSize: 0.85,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shrinkWrap: true,
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            'Coupon: $qrCode',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          iconSize: 28,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: qrCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Coupon kopiert')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: BarcodeWidget(
                        data: qrCode,
                        barcode: Barcode.qrCode(),
                        width: 200,
                        height: 200,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),

                  // URL with copy button
                  Column(
                    children: [
                      if (website != null && website.trim().isNotEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Website: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                Flexible(
                                  child: InkWell(
                                    onTap: () => openLink(context, website),
                                    child: Text(
                                      website,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (location != null && location.trim().isNotEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Location: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                Flexible(
                                  child: InkWell(
                                    onTap: () => openLink(context, location),
                                    child: Text(
                                      location,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemesNotifier>(context).currentThemeData;
    final Coupon coupon = Coupon.fromMap(widget.deal);
    final couponUserBackend = sl<CouponUserBackendRepository>();
    const userId = '6822fb140013c217724f';

    Future<CouponUser> fetchUserData() async {
      try {
        return await couponUserBackend.getUserCoupons(userId);
      } catch (e) {
        debugPrint('Error fetching user data: $e');

        return CouponUser(
          userId: userId,
        );
      }
    }

    return FutureBuilder<CouponUser>(
      future: fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final user = snapshot.data ??
            CouponUser(
              userId: userId,
              favoriteCoupons: [],
              likedCoupons: [],
              dislikedCoupons: [],
              userMaxCoupons: [],
            );

        final title = coupon.title;
        final description = coupon.description;
        final List<String>? images = coupon.images;

        final oldPrice = coupon.oldPrice;
        final newPrice = coupon.newPrice;
        final provider = coupon.provider;
        final discount = coupon.discount;
        final website = coupon.website;
        final location = coupon.location;
        final qrCode = coupon.qrCode;

        final List<String> userMaxCoupons = user.userMaxCoupons ?? [];
        final Map<String, int> couponLimits = {};

        // Parse coupon limits from user data example : (asfwfqwf:30) = (userid:userMaxCoupons)
        for (final entry in userMaxCoupons) {
          final parts = entry.split(':');
          if (parts.length == 2) {
            final couponId = parts[0];
            final limit = int.tryParse(parts[1]) ?? 1;
            couponLimits[couponId] = limit;
          }
        }

        int remainingUses = couponLimits[coupon.id] ?? coupon.availableCoupons ?? 1;

        //Nutzungslogik

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    // --- AppBar / Header ---
                    Padding(
                      padding: EdgeInsets.only(
                        top: Platform.isAndroid ? 10 : 0,
                        bottom: 10,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Back button
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Align(
                              child: Text(
                                'Coupon-Details',
                                style: theme.textTheme.displayMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- Hauptinhalt ---
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bild
                            if (images != null && images.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: SizedBox(
                                  height: 240,
                                  child: PageView.builder(
                                    itemCount: images.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              // Tap to view full screen
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => FullScreenImage(
                                                        imageUrls: images,
                                                        initialIndex: index,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: AspectRatio(
                                                  aspectRatio: 16 / 9,
                                                  child: Image.network(
                                                    images[index],
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        color: Colors.grey[200],
                                                        child: const Icon(Icons.broken_image),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              // Image counter
                                              Positioned(
                                                bottom: 6,
                                                right: 8,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.6),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    '${index + 1}/${images.length}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            // Placeholder when no images
                            else
                              Container(
                                height: 200,
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_not_supported, size: 50),
                              ),

                            const SizedBox(height: 8),

                            // Titel
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        title,
                                        maxLines: 1,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        provider,
                                        maxLines: 2,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontSize: 16,
                                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Preis / Discount oder Quelle
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  if (oldPrice != null && newPrice != null) ...[
                                    Text(
                                      '$oldPrice€',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 6),

                                    // Discounted price
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        '$newPrice€',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                          shadows: [
                                            Shadow(
                                              color: theme.colorScheme.primary.withOpacity(0.1),
                                              blurRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  // Discount box
                                  if (discount != null || (oldPrice != null && newPrice != null))
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: (oldPrice == null || newPrice == null) ? 30 : 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.shade100.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: discount != null
                                          ? Text(
                                              discount,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            )
                                          : Text(
                                              '${((oldPrice! - newPrice!) / oldPrice * 100).round()}%',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                    )
                                  else
                                    const Text(
                                      'Kein Preis verfügbar',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),
                            // Description section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Scrollbar(
                                    thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        (description == null || description == '')
                                            ? 'Keine Details Verfügbar.'
                                            : description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                          color: theme.colorScheme.onSurface.withOpacity(0.9),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Floating button positioned at the bottom
                Positioned(
                  bottom: 25,
                  left: 120,
                  right: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 40),
                      textStyle: theme.textTheme.labelMedium,
                      shape: RoundedRectangleBorder(
                        // Explicit shape
                        borderRadius: BorderRadius.circular(10), // Custom radius
                      ),
                    ),
                    onPressed: () async {
                      // show the QR code
                      final hasWebsite = website?.trim().isNotEmpty ?? false;
                      final hasLocation = location?.trim().isNotEmpty ?? false;

                      if (hasWebsite || hasLocation) {
                        showQrCodeBottomSheet(
                          context,
                          qrCode,
                          website: hasWebsite ? website : null,
                          location: hasLocation ? location : null,
                        );
                      } else {
                        showQrCodeBottomSheet(context, qrCode);
                      }
                      // Update remaining uses
                      final newRemainingUses = remainingUses - 1;

                      final updatedCouponLimits = <String>[];
                      bool couponFound = false;

                      // Update user coupon limits
                      for (final entry in userMaxCoupons) {
                        final parts = entry.split(':');
                        if (parts.length == 2 && parts[0] == coupon.id) {
                          updatedCouponLimits.add('${coupon.id}:$newRemainingUses');
                          couponFound = true;
                        } else {
                          updatedCouponLimits.add(entry);
                        }
                      }
                      if (!couponFound) {
                        updatedCouponLimits.add('${coupon.id}:$newRemainingUses');
                      }
                      // Update UI
                      setState(() {
                        user.userMaxCoupons = updatedCouponLimits;
                        remainingUses = newRemainingUses;
                      });
                      // Update backend
                      await couponUserBackend.updateUserCoupons(
                        userId: userId,
                        updatedFields: {'userMaxCoupons': updatedCouponLimits},
                      );
                    },
                    child: const Text('Jetzt einlösen'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
