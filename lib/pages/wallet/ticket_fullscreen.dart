import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:pdfx/pdfx.dart';
import 'package:screen_brightness/screen_brightness.dart';

import 'package:campus_app/core/themes.dart';

import 'package:campus_app/utils/widgets/campus_icon_button.dart';

class BogestraTicketFullScreen extends StatefulWidget {
  const BogestraTicketFullScreen({Key? key}) : super(key: key);

  @override
  State<BogestraTicketFullScreen> createState() => _BogestraTicketFullScreenState();
}

class _BogestraTicketFullScreenState extends State<BogestraTicketFullScreen> {
  Image? qrCodeImage;

  Future<Image> renderQRCode(String path) async {
    final document = await PdfDocument.openFile(path);
    final page = await document.getPage(1);
    final pageImage = await page.render(
      width: page.width * 2.4,
      height: page.height * 2.4,
      cropRect: Rect.fromLTWH(174, 250, page.width - 325, 269),
    );
    await page.close();

    if (pageImage == null) {
      return Image(image: MemoryImage(Uint8List.fromList([0])));
    }

    return Image(
      image: MemoryImage(pageImage.bytes),
    );
  }

  /// Loads the previously saved image of the semester ticket and
  /// the corresponding aztec-code
  Future<void> loadTicket() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Define the image files
    final File ticketFile = File('$directoryPath/ticket.pdf');

    // If the images were parsed and saved in the past, they're loaded
    final bool tickedSaved = ticketFile.existsSync();
    if (tickedSaved) {
      final Image qrCodeImage = await renderQRCode(ticketFile.path);

      setState(() {
        this.qrCodeImage = qrCodeImage;
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    setBrightness(1);

    loadTicket();
  }

  @override
  void dispose() {
    super.dispose();

    resetBrightness();
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
                  ],
                ),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height / 2) + 40,
              alignment: Alignment.center,
              child: qrCodeImage ?? Container(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to reset brightness';
    }
  }
}
