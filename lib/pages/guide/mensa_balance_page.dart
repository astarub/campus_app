import 'dart:io' show Platform;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;

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

  /// Initialises the NFC session and starts scanning for a tag, if NFC is activated on the device.
  void initialiseNFC() async {
    final NFCAvailability availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      debugPrint('NFC not activated on device.');
      setState(() => nfcAvailable = false);
    } else {
      debugPrint('NFC is activated on device. Start scanning for a card...');
      // Start scanning for a NFC tag
      final NFCTag scannedTag = await FlutterNfcKit.poll(
          timeout: const Duration(seconds: 10),
          iosMultipleTagMessage: 'Mehrere NFC-Tags gefunden! Versuche es noch einmal.',
          iosAlertMessage: 'Scanne deine Karte.');

      debugPrint('Scanned mensa card: ${jsonEncode(scannedTag)}');
      parseNFCTag(scannedTag);
    }
  }

  /// Parses the scanned NFC tag from the mensa card
  void parseNFCTag(NFCTag tag) async {
    if (tag.ndefAvailable != null && tag.ndefAvailable!) {
      /// decoded NDEF records (see [ndef.NDEFRecord] for details)
      /// `UriRecord: id=(empty) typeNameFormat=TypeNameFormat.nfcWellKnown type=U uri=https://github.com/nfcim/ndef`
      for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
        debugPrint(record.toString());
      }

      /// raw NDEF records (data in hex string)
      /// `{identifier: "", payload: "00010203", type: "0001", typeNameFormat: "nfcWellKnown"}`
      for (var record in await FlutterNfcKit.readNDEFRawRecords(cached: false)) {
        debugPrint(jsonEncode(record).toString());
      }
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
