// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io' show Platform;
import 'package:campus_app/core/backend/backend_repository.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/coupons/coupon_backend/coupon_entity.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/coupons/coupon_backend/coupon_user_backend_repository.dart';
import 'package:campus_app/pages/coupons/coupon_backend/coupon_user_entity.dart';
import 'package:campus_app/pages/coupons/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:campus_app/core/themes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:campus_app/pages/coupons/full_screen_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// CouponDetailPage widget that displays detailed information about a coupon
// Widget, das detaillierte Informationen über einen Coupon anzeigt
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
  // State variables for managing UI states
  // Zustandsvariablen für die Verwaltung von UI-Zuständen
  bool showSuccessAnimation = false;
  bool showNetworkError = false;
  bool showInvalidCodeError = false;
  int? _couponUsesCounter;
  int? _availableCoupons;
  List<String>? _userMaxCoupons;

// Function to open external links
  // Funktion zum Öffnen externer Links
  Future openLink(BuildContext context, String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize coupon data from widget
    // Initialisiert Coupon-Daten aus dem Widget
    final coupon = Coupon.fromMap(widget.deal);
    _couponUsesCounter = coupon.couponUsesCounter;
    _availableCoupons = coupon.availableCoupons;
  }

// Shows a success animation dialog when coupon is redeemed successfully
  // Zeigt einen Erfolgsanimation-Dialog an, wenn der Coupon erfolgreich eingelöst wurde
  void showSuccessAnimationDialog() {
    showDialog(
      context: context,
      barrierColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animation Stack
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Celebration effect - background layer
                        // Feiereffekt - Hintergrundebene
                        Lottie.asset(
                          'assets/animations/celebration-effect.json',
                          width: 800,
                          height: 400,
                          fit: BoxFit.cover,
                          repeat: false,
                          onLoaded: (composition) {
                            Future.delayed(composition.duration * 2, () {
                              if (mounted) {
                                Navigator.of(context).pop();
                              }
                            });
                          },
                        ),
                        // Success effect - foreground layer
                        // Erfolgseffekt - Vordergrundebene
                        Lottie.asset(
                          'assets/animations/success-effect.json',
                          width: 400,
                          height: 400,
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Text(
                      'Gutschein erfolgreich eingelöst.',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// Shows a network error dialog when there's no internet connection
  // Zeigt einen Netzwerkfehler-Dialog an, wenn keine Internetverbindung besteht
  void showNetworkErrorDialog() {
    showDialog(
      context: context,
      barrierColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/networkError-effect.json',
                    width: 250,
                    height: 250,
                    repeat: false,
                    onLoaded: (composition) {
                      Future.delayed(composition.duration * 1.7, () {
                        if (mounted) Navigator.of(context).pop();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Netzwerkfehler',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bitte Internetverbindung überprüfen.',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Shows an error dialog when an invalid QR code is scanned
  // Zeigt einen Fehlerdialog an, wenn ein ungültiger QR-Code gescannt wurde
  void showInvalidCodeErrorDialog() {
    showDialog(
      context: context,
      barrierColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/errorX-effect.json',
                    width: 200,
                    height: 200,
                    repeat: false,
                    onLoaded: (composition) {
                      Future.delayed(composition.duration * 1.7, () {
                        if (mounted) Navigator.of(context).pop();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ungültiger QR-Code',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bitte gültigen Coupon-QR-Code scannen.',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Shows a bottom sheet containing a QR code (snapping sheet)
  // Optionally shows website/link below the QR code
  // Zeigt ein BottomSheet mit einem QR-Code (snapping sheet)
  // Zeigt optional eine Website/Verlinkung unter dem QR-Code an
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
                  // URL mit Kopier-Button
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
                                  'Standort: ',
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
    final couponBackend = sl<BackendRepository>();
    final SettingsHandler settingsHandler = Provider.of<SettingsHandler>(context, listen: false);

    return FutureBuilder<CouponUser>(
      future: couponUserBackend.getUserCoupons(settingsHandler.currentSettings.backendAccount.id),
      builder: (context, snapshot) {
        // Loading state
        // Ladezustand
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Error state
        // Fehlerzustand
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: SafeArea(
              child: Column(
                children: [
                  // AppBar
                  Padding(
                    padding: EdgeInsets.only(
                      top: Platform.isAndroid ? 10 : 0,
                      bottom: 10,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
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
                  // Error message
                  // Fehlermeldung
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off,
                            size: 64,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Keine Internetverbindung',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bitte Verbindung prüfen und erneut versuchen',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              textStyle: theme.textTheme.labelMedium,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text('Erneut versuchen'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        // Success state - display coupon details
        // Erfolgszustand - Coupon-Details anzeigen
        final user = snapshot.data!;

        _userMaxCoupons ??= user.userMaxCoupons ?? [];

        // Extract coupon data
        // Coupon-Daten extrahieren
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
        final hiddenQrCode = coupon.hiddenQrCode;
        final couponUsesCounter = _couponUsesCounter ?? coupon.couponUsesCounter ?? 0;
        final availableCoupons = _availableCoupons ?? coupon.availableCoupons;

        final List<String> userMaxCoupons = _userMaxCoupons ?? [];
        final Map<String, int> couponLimits = {};

        // Parse coupon limits from user data example: (asfwfqwf:30) = (userid:userMaxCoupons)
        // Coupon-Limits aus Benutzerdaten parsen Beispiel: (asfwfqwf:30) = (userid:userMaxCoupons)
        for (final entry in userMaxCoupons) {
          final parts = entry.split(':');
          if (parts.length == 2) {
            final couponId = parts[0];
            final limit = int.tryParse(parts[1]) ?? 1;
            couponLimits[couponId] = limit;
          }
        }

// Calculate remaining uses for this coupon
        // Verbleibende Nutzungen für diesen Coupon berechnen
        final int remainingUses = couponLimits[coupon.id] ?? availableCoupons ?? 5;

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
                            // Zurück-Button
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

                    // --- Main content ---
                    // --- Hauptinhalt ---
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            // Bild
                            if (images == null || images.isEmpty)
                              const SizedBox.shrink()
                            else
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
                                                        color: Colors.grey[600],
                                                        child: const Icon(Icons.image_not_supported),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
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
                              ),

                            const SizedBox(height: 8),

                            // Title
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
                                    child: Text(
                                      provider,
                                      maxLines: 2,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontSize: 16,
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // old Price
                            // alterPreis
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
                                    // Reduzierter Preis
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
                                  // display Discount %
                                  // Rabatt % anzeigen
                                  if (oldPrice != null && newPrice != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.shade100.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        newPrice == 0
                                            ? 'Free 🎉'
                                            : '${newPrice > oldPrice ? '+' : '-'}${((oldPrice - newPrice).abs() / oldPrice * 100).round()}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    )
                                  else if (discount != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.shade100.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        discount,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
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
                            // Beschreibungsabschnitt
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

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Floating button positioned at the bottom
                // Schwebtaste am unteren Rand positioniert
                Positioned(
                  bottom: 25,
                  left: 10,
                  right: 10,
                  child: remainingUses <= 0
                      ? SizedBox(
                          width: double.infinity,
                          child: AbsorbPointer(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                disabledBackgroundColor: theme.colorScheme.primary,
                                disabledForegroundColor: Colors.deepOrange,
                                minimumSize: const Size(double.infinity, 40),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                textStyle: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.grey[400]!),
                                ),
                              ),
                              onPressed: null,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.block, size: 20),
                                  SizedBox(width: 8),
                                  Text('Coupon-Limit erreicht'),
                                ],
                              ),
                            ),
                          ),
                        )
                      : () {
                          // Check which buttons to show based on QR code availability
                          // Überprüfen, welche Buttons basierend auf der QR-Code-Verfügbarkeit angezeigt werden sollen
                          final hasHiddenQr = hiddenQrCode != null && hiddenQrCode.trim().isNotEmpty;
                          final hasQrCode = qrCode != null && qrCode.trim().isNotEmpty;

                          if (hasHiddenQr && hasQrCode) {
                            // Show both buttons
                            // Beide Buttons anzeigen
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Scan Coupon Button
                                // Coupon scannen Button
                                SizedBox(
                                  width: 175,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.primary,
                                      foregroundColor: theme.colorScheme.onPrimary,
                                      minimumSize: const Size(double.infinity, 40),
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      textStyle: theme.textTheme.labelMedium,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final scannedData = await Navigator.push<String>(
                                        context,
                                        MaterialPageRoute(builder: (context) => const QRScanner()),
                                      );

                                      if (scannedData == null) return;
                                      // Check internet connection
                                      // Internetverbindung überprüfen
                                      final connectivityResult = await Connectivity().checkConnectivity();
                                      if (connectivityResult == ConnectivityResult.none) {
                                        showNetworkErrorDialog();
                                        return;
                                      }
                                      if (scannedData == hiddenQrCode) {
                                        // Update counters and remaining uses
                                        // Zähler und verbleibende Nutzungen aktualis
                                        final newCounter = couponUsesCounter + 1;
                                        final availableCounter = availableCoupons != null ? availableCoupons - 1 : null;
                                        final newRemainingUses = remainingUses - 1;

                                        final updatedCouponLimits = <String>[];
                                        bool couponFound = false;

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

                                        setState(() {
                                          _couponUsesCounter = newCounter;
                                          _availableCoupons = availableCounter;
                                          _userMaxCoupons = updatedCouponLimits;
                                        });
                                        // Update backend with new values
                                        // Backend mit neuen Werten aktualisieren

                                        await couponBackend.updateCoupon(
                                          couponId: coupon.id,
                                          updatedFields: {
                                            'couponUsesCounter': newCounter,
                                            'availableCoupons': availableCounter,
                                          },
                                        );
                                        await couponUserBackend.updateUserCoupons(
                                          updatedFields: {'userMaxCoupons': updatedCouponLimits},
                                        );
                                        showSuccessAnimationDialog();
                                      } else {
                                        showInvalidCodeErrorDialog();
                                      }
                                    },
                                    child: const Text('Coupon scannen'),
                                  ),
                                ),
                                // Redeem Button
                                // Einlösen Button
                                SizedBox(
                                  width: 175,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.primary,
                                      foregroundColor: theme.colorScheme.onPrimary,
                                      minimumSize: const Size(double.infinity, 40),
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      textStyle: theme.textTheme.labelMedium,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () async {
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
                                    },
                                    child: const Text('Coupon einlösen'),
                                  ),
                                ),
                              ],
                            );
                          } else if (hasHiddenQr) {
                            // Show only scan button
                            // Nur Scan-Button anzeigen
                            return Center(
                              child: SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor: theme.colorScheme.onPrimary,
                                    minimumSize: const Size(250, 40),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    textStyle: theme.textTheme.labelMedium,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final scannedData = await Navigator.push<String>(
                                      context,
                                      MaterialPageRoute(builder: (context) => const QRScanner()),
                                    );

                                    if (scannedData == null) return;

                                    final connectivityResult = await Connectivity().checkConnectivity();
                                    if (connectivityResult == ConnectivityResult.none) {
                                      showNetworkErrorDialog();
                                      return;
                                    }
                                    if (scannedData == hiddenQrCode) {
                                      final newCounter = couponUsesCounter + 1;
                                      final availableCounter = availableCoupons != null ? availableCoupons - 1 : null;
                                      final newRemainingUses = remainingUses - 1;

                                      final updatedCouponLimits = <String>[];
                                      bool couponFound = false;

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

                                      setState(() {
                                        _couponUsesCounter = newCounter;
                                        _availableCoupons = availableCounter;
                                        _userMaxCoupons = updatedCouponLimits;
                                      });

                                      await couponBackend.updateCoupon(
                                        couponId: coupon.id,
                                        updatedFields: {
                                          'couponUsesCounter': newCounter,
                                          'availableCoupons': availableCounter,
                                        },
                                      );
                                      await couponUserBackend.updateUserCoupons(
                                        updatedFields: {'userMaxCoupons': updatedCouponLimits},
                                      );
                                      showSuccessAnimationDialog();
                                    } else {
                                      showInvalidCodeErrorDialog();
                                    }
                                  },
                                  child: const Text('Coupon scannen'),
                                ),
                              ),
                            );
                          } else if (hasQrCode) {
                            // Show only redeem button
                            // Nur Einlösen-Button anzeigen
                            return Center(
                              child: SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor: theme.colorScheme.onPrimary,
                                    minimumSize: const Size(250, 40),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    textStyle: theme.textTheme.labelMedium,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
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
                                  },
                                  child: const Text('Coupon einlösen'),
                                ),
                              ),
                            );
                          } else {
                            // Show nothing if neither QR code exists
                            // Nichts anzeigen, wenn kein QR-Code existiert
                            return const SizedBox.shrink();
                          }
                        }(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
