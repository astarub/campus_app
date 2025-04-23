import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1) Use barcode_widget instead of qr_flutter:
import 'package:barcode_widget/barcode_widget.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/more/in_app_web_view_page.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponDetailPage extends StatefulWidget {
  final Map<String, dynamic> deal;

  const CouponDetailPage({
    Key? key,
    required this.deal,
  }) : super(key: key);

  @override
  State<CouponDetailPage> createState() => _CouponDetailPageState();
}

class _CouponDetailPageState extends State<CouponDetailPage> {
  /// Öffnet einen Link - übernimmt die Logik aus deinem `MorePage`-Beispiel
  /// (extern oder In-App).
  void openLink(BuildContext context, String url) async {
    final useExternal = Provider.of<SettingsHandler>(context, listen: false).currentSettings.useExternalBrowser;

    if (useExternal ||
        url.contains('instagram') ||
        url.contains('facebook') ||
        url.contains('twitch') ||
        url.contains('mailto:') ||
        url.contains('tel:')) {
      // Externer Browser
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      // Interner Browser (InAppWebView)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InAppWebViewPage(url: url)),
      );
    }
  }

  /// Zeigt ein BottomSheet, das einen QR-Code enthält (snapping sheet).
  /// Unter dem QR-Code kann ggf. noch der Link stehen.
  void showQrCodeBottomSheet(BuildContext context, String qrData, {String? url}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // wichtig, damit DraggableScrollableSheet funktioniert
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.85,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Provider.of<ThemesNotifier>(this.context).currentThemeData.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(16.0),
                children: [
                  // 2) Generate QR code using BarcodeWidget:
                  Center(
                    child: BarcodeWidget(
                      data: qrData,
                      barcode: Barcode.qrCode(), // Generate QR code
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Falls zusätzlich ein Link da sein soll, zeige ihn an.
                  if (url != null)
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Zusätzlicher Link:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => openLink(context, url),
                            child: Text(
                              url,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
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
    final deal = widget.deal;

    // Daten aus dem Deal holen
    final title = deal['title'] ?? '';
    final imagePath = deal['image'];
    final oldPrice = deal['oldPrice'];
    final newPrice = deal['newPrice'];
    final source = deal['source'];
    final url = deal['url']; // Link
    final qrCodeData = deal['qrCodeData']; // QR-Code
    //Nutzungslogik
    final int maxUses = deal['maxUses'] ?? 1;
    final int usedCount = deal['usedCount'] ?? 0;
    final bool isValid = usedCount < maxUses;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // --- AppBar / Header ---
            Padding(
              padding: EdgeInsets.only(
                top: Platform.isAndroid ? 10 : 0,
                bottom: 20,
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

            // --- Hauptinhalt ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bild
                    if (imagePath != null)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        color: theme.colorScheme.surfaceVariant,
                        child: const Center(child: Text('Kein Bild vorhanden')),
                      ),

                    const SizedBox(height: 16),

                    // Titel
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Preis / Discount oder Quelle
                    if (newPrice != null)
                      Row(
                        children: [
                          if (oldPrice != null) ...[
                            Text(
                              '${oldPrice.toString()}€',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            '${newPrice.toString()}€',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      )
                    else
                      // Quelle, falls kein Preis vorhanden
                      Text(
                        source ?? 'Unbekannte Quelle',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Beispiel: weiterer Coupon-Text
                    const Text(
                      'Hier könnte eine ausführlichere Beschreibung des Coupons oder '
                      'besondere Teilnahmebedingungen, Einlösevoraussetzungen etc. stehen.',
                    ),
                    const SizedBox(height: 40),
                    //Anzeige, ob Gutschein noch gültig ist (Nutzungsstatus)
                    Text(
                      isValid
                          ? 'Gutschein gültig (${usedCount} von ${maxUses} verwendet)'
                          : 'Gutschein nicht mehr gültig',
                      style: TextStyle(
                        fontSize: 16,
                        color: isValid ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // --- Button-Bereich (Link / QR / beides) ---
                    Align(
                      alignment: Alignment.center,
                      child: isValid //Wenn der Gutschein gültig ist ...
                          ? ElevatedButton(
                              onPressed: () {
                                // 1. Aktion ausführen / Gutschein nutzen
                                //Zeige QR-Code + Link
                                if (qrCodeData != null && url != null) {
                                  showQrCodeBottomSheet(context, qrCodeData, url: url);
                                }
                                //Nur QR-Code vorhanden
                                else if (qrCodeData != null) {
                                  showQrCodeBottomSheet(context, qrCodeData);
                                }
                                //Nur Link vorhanden
                                else if (url != null) {
                                  openLink(context, url);
                                }
                                //Weder QR-Code noch Link vorhanden
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Keine weiteren Informationen verfügbar.'),
                                    ),
                                  );
                                }

                                // 2. Nutzung hochzählen
                                setState(() {
                                  deal['usedCount'] = usedCount + 1;
                                });
                              },
                              child: const Text('Jetzt einlösen'),
                            )

                          //Wenn der Gutschein nicht mehr gültig ist ...
                          : const ElevatedButton(
                              onPressed: null, //Button deaktivieren (grau & nicht klickbar)
                              child: Text('Nicht mehr gültig'),
                            ),
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
}
