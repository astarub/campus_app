import 'dart:io' show Platform;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'dart:typed_data';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/empty_state_placeholder.dart';

class MensaBalancePage extends StatefulWidget {
  const MensaBalancePage({Key? key}) : super(key: key);

  @override
  State<MensaBalancePage> createState() => _MensaBalancePageState();
}

class _MensaBalancePageState extends State<MensaBalancePage> {
  bool nfcAvailable = true;

  double byteArrayToDouble(Uint8List b, int offset, int length) {
    double value = 0;
    for (int i = 0; i < length; i++) {
      final int shift = (length - 1 - i) * 8;
      value += (b[i + offset] & 0x000000FF) << shift;
    }
    return value;
  }
  /// Initialises the NFC session and starts scanning for a tag, if NFC is activated on the device.
  void initialiseNFC() async {
    final NFCAvailability availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      debugPrint('NFC not activated on device.');
      setState(() => nfcAvailable = false);
    } else {
      debugPrint('NFC is activated on device. Start scanning for a card...');

      // Start scanning for a NFC tag
      NFCTag scannedTag;
      try {
        scannedTag = await FlutterNfcKit.poll(
            timeout: const Duration(seconds: 10),
            iosMultipleTagMessage: 'Mehrere NFC-Tags gefunden! Versuche es noch einmal.',
            iosAlertMessage: 'Scanne deine Karte.');

      } catch (e) {
        switch (e.runtimeType) {
          case PlatformException: {
            debugPrint('Timeout');
          }
        }
        return;
      }

      debugPrint('Scanned mensa card: ${jsonEncode(scannedTag)}');

      // Select application
      await FlutterNfcKit.transceive(Uint8List.fromList([0x90, 0x5A, 0x00, 0x00, 3, (0x5F8415 & 0xFF0000) >> 16, (0x5F8415 & 0xFF00) >> 8, 0x5F8415 & 0xFF, 0x00]));

      // Get file settings
      await FlutterNfcKit.transceive(Uint8List.fromList([0x90, 0xF5, 0x00, 0x00, 1, 1, 0x00]));

      // Read value
      final result = Uint8List.fromList(await FlutterNfcKit.transceive(Uint8List.fromList([0x90, 0x6C, 0x00, 0x00, 1, 1, 0x00]))).toReverse();
      // Get all bytes after the status and placeholder bytes
      final resultBytes = Uint8List.fromList(result.getRange(4, 6).toList());

      // Mensa card balance
      final balance = byteArrayToDouble(Uint8List.fromList(result.getRange(4, 6).toList()), 0, resultBytes.length).toInt() / 1000;
      debugPrint(balance.toString());

    }
  }

  @override
  void initState() {
    super.initState();

    initialiseNFC();
  }

  @override
  void dispose() {
    super.dispose();

    FlutterNfcKit.finish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: Platform.isAndroid ? 20 : 0),
        child: Column(
          children: [
            // Back button & page title
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    CampusIconButton(
                      iconPath: 'assets/img/icons/arrow-left.svg',
                      onTap: () => Navigator.pop(context),
                    ),
                    Align(
                      child: Text(
                        'Mensa Guthaben',
                        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: nfcAvailable
                  ? Placeholder()
                  : const EmptyStatePlaceholder(
                      title: 'NFC deaktiviert',
                      text: 'Um das Guthaben deiner Mensa Karte auslesen zu können, muss NFC aktiviert sein.',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
