import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:screen_brightness/screen_brightness.dart';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_usecases.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BogestraTicketFullScreen extends StatefulWidget {
  const BogestraTicketFullScreen({Key? key}) : super(key: key);

  @override
  State<BogestraTicketFullScreen> createState() => _BogestraTicketFullScreenState();
}

class _BogestraTicketFullScreenState extends State<BogestraTicketFullScreen> {
  Image? aztecCodeImage;

  TicketUsecases ticketUsecases = sl<TicketUsecases>();

  /// Loads the previously saved image of the semester ticket and
  /// the corresponding aztec-code
  Future<void> renderTicket() async {
    final Image? aztecCodeImage = await ticketUsecases.renderAztecCode();

    if (aztecCodeImage != null) {
      setState(() {
        this.aztecCodeImage = aztecCodeImage;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    setBrightness(1);

    renderTicket();
  }

  @override
  void dispose() {
    super.dispose();

    resetBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('ticket-key'),
      onVisibilityChanged: (info) {
        final bool isVisible = info.visibleFraction > 0;

        if (isVisible) {
          setBrightness(1);
        } else {
          resetBrightness();
        }
      },
      child: Scaffold(
        backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
        body: Padding(
          padding: EdgeInsets.only(top: Platform.isAndroid ? 20 : 0),
          child: Column(
            children: [
              // Back button & page title
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      CampusIconButton(
                        iconPath: 'assets/img/icons/arrow-left.svg',
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: Platform.isIOS ? 88 : 68),
                  child: Center(
                    child: aztecCodeImage ?? Container(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
