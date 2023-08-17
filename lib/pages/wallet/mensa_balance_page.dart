import 'dart:io' show Platform;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:lottie/lottie.dart';

import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/empty_state_placeholder.dart';
import 'package:campus_app/utils/widgets/animated_number.dart';

class MensaBalancePage extends StatefulWidget {
  const MensaBalancePage({Key? key}) : super(key: key);

  @override
  State<MensaBalancePage> createState() => _MensaBalancePageState();
}

class _MensaBalancePageState extends State<MensaBalancePage> with TickerProviderStateMixin {
  bool nfcAvailable = true;
  bool tagScanned = false;
  double cardBalance = 0;
  double lastTransaction = 0;

  late AnimationController successAnimationController;

  void saveMensaCardData(double scannedBalance, double lastTransaction) {
    final Settings newSettings = Provider.of<SettingsHandler>(context, listen: false)
        .currentSettings
        .copyWith(lastMensaBalance: scannedBalance, lastMensaTransaction: lastTransaction);

    debugPrint(
      'Saving scanned mensa card data: Balance=${newSettings.lastMensaBalance}, Last Transaction: ${newSettings.lastMensaTransaction}',
    );
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  double byteArrayToDouble(Uint8List b, int offset, int length) {
    double value = 0;
    for (int i = 0; i < length; i++) {
      final int shift = (length - 1 - i) * 8;
      value += (b[i + offset] & 0x000000FF) << shift;
    }
    return value;
  }

  Future<void> transceiveMensaBalance() async {
    try {
      // Select application
      await FlutterNfcKit.transceive(
        Uint8List.fromList(
          [0x90, 0x5A, 0x00, 0x00, 3, (0x5F8415 & 0xFF0000) >> 16, (0x5F8415 & 0xFF00) >> 8, 0x5F8415 & 0xFF, 0x00],
        ),
      );

      // Get the transaction history file
      final transactionFile = await FlutterNfcKit.transceive(
        Uint8List.fromList([0x90, 0xF5, 0x00, 0x00, 1, 1, 0x00]),
      );

      // Read value from mensa card
      final result = Uint8List.fromList(
        await FlutterNfcKit.transceive(
          Uint8List.fromList([0x90, 0x6C, 0x00, 0x00, 1, 1, 0x00]),
        ),
      ).reversed.toList();

      // Mensa card data
      setState(() {
        tagScanned = true;

        // Get all bytes that represent the mensa card value
        cardBalance = byteArrayToDouble(
              Uint8List.fromList(result.getRange(4, result.length).toList()),
              0,
              result.length - 4,
            ).toInt() /
            1000;

        // Get the last transaction from the scanned mensa card
        lastTransaction = byteArrayToDouble(
              Uint8List.fromList(
                transactionFile.getRange(12, 16).toList().reversed.toList(),
              ),
              0,
              4,
            ).toInt() /
            1000;
      });
      debugPrint('Scanned mensa card nfc tag parsed: $cardBalance');

      saveMensaCardData(cardBalance, lastTransaction);

      if (Platform.isIOS) await FlutterNfcKit.finish(iosAlertMessage: 'Mensakarte erkannt!');
    } catch (e) {
      debugPrint('Error while scanning mensa card. Trying again...');
    }
  }

  /// Initialises the NFC session and starts scanning for a tag, if NFC is activated on the device.
  /// If a tag was scanned, it's parsed to display the current card balance.
  Future<void> initialiseNFC() async {
    final NFCAvailability availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      debugPrint('NFC not activated on device.');
      setState(() => nfcAvailable = false);
    } else {
      debugPrint('NFC is activated on device. Start scanning for a card...');

      // Differentiate between Android and iOS as constant NFC polling is impossible on iOS
      if (Platform.isIOS) {
        // Start scanning for a NFC tag
        NFCTag scannedTag;
        try {
          scannedTag = await FlutterNfcKit.poll(
            timeout: const Duration(seconds: 10),
            readIso15693: false,
            iosMultipleTagMessage: 'Mehrere NFC-Tags gefunden! Versuche es noch einmal.',
            iosAlertMessage: 'Scanne deine Karte.',
          );
        } catch (e) {
          switch (e.runtimeType) {
            case PlatformException:
              {
                debugPrint('Timeout while waiting for a nfc scan.');
              }
          }
          return;
        }

        debugPrint('Scanned mensa card: ${jsonEncode(scannedTag)}');

        await transceiveMensaBalance();
      } else if (Platform.isAndroid) {
        while (mounted) {
          // Start scanning for a NFC tag
          NFCTag scannedTag;
          try {
            scannedTag = await FlutterNfcKit.poll(
              timeout: const Duration(seconds: 10),
              readIso15693: false,
              iosMultipleTagMessage: 'Mehrere NFC-Tags gefunden! Versuche es noch einmal.',
              iosAlertMessage: 'Scanne deine Karte.',
            );
          } catch (e) {
            switch (e.runtimeType) {
              case PlatformException:
                {
                  debugPrint('Timeout while waiting for a nfc scan.');
                }
            }
            continue;
          }

          debugPrint('Scanned mensa card: ${jsonEncode(scannedTag)}');

          await transceiveMensaBalance();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    successAnimationController = AnimationController(vsync: this);

    initialiseNFC();
  }

  @override
  void dispose() {
    super.dispose();

    successAnimationController.dispose();
    FlutterNfcKit.finish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
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
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: tagScanned ? 100 : 0),
                          child: AnimatedOpacity(
                            opacity: tagScanned ? 1 : 0,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeIn,
                            child: Column(
                              children: [
                                // Coin Illustration
                                Lottie.asset(
                                  'assets/animations/coin-flip.json',
                                  height: 80,
                                  controller: successAnimationController,
                                  onLoaded: (composition) {
                                    successAnimationController.duration = composition.duration;
                                  },
                                ),
                                // Current balance
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Guthaben: ',
                                      style:
                                          Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                                    ),
                                    AnimatedNumberText<double>(
                                      cardBalance,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeIn,
                                      style:
                                          Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                                      formatter: (value) => value.toStringAsFixed(2),
                                      onEnd: () {
                                        successAnimationController.forward();
                                      },
                                    ),
                                    Text(
                                      ' €',
                                      style:
                                          Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                                    ),
                                  ],
                                ),
                                // Last transaction
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text('Letzte Abbuchung: -${lastTransaction.toStringAsFixed(2)} €'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Scan card notification
                        if (!tagScanned)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: Provider.of<SettingsHandler>(context).currentSettings.lastMensaBalance != null
                                  ? 100
                                  : 180,
                            ),
                            child: Column(
                              children: [
                                if (Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light)
                                  Lottie.asset(
                                    'assets/animations/nfc-light.json',
                                    height: 180,
                                  )
                                else
                                  Lottie.asset('assets/animations/nfc-dark.json'),
                                const EmptyStatePlaceholder(
                                  title: 'Karte scannen',
                                  text: 'Halte deinen Studierendenausweis an dein Smartphone, um ihn zu scannen.',
                                ),
                              ],
                            ),
                          )
                      ],
                    )
                  : const EmptyStatePlaceholder(
                      title: 'NFC deaktiviert',
                      text: 'Um dein AKAFÖ Guthaben auslesen zu können, muss NFC aktiviert sein.',
                    ),
            ),
            if (Provider.of<SettingsHandler>(context).currentSettings.lastMensaBalance != null &&
                Provider.of<SettingsHandler>(context).currentSettings.lastMensaTransaction != null &&
                !tagScanned)
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 60),
                child: Column(
                  children: [
                    Text(
                      'Letztes Guthaben: ${Provider.of<SettingsHandler>(context).currentSettings.lastMensaBalance} €',
                    ),
                    Text(
                      'Letzte gescannte Abbuchung: -${Provider.of<SettingsHandler>(context).currentSettings.lastMensaTransaction} €',
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
