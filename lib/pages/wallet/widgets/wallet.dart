import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screen_brightness/screen_brightness.dart';

import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/wallet/ticket_fullscreen.dart';
import 'package:campus_app/pages/wallet/widgets/stacked_card_carousel.dart';
import 'package:campus_app/pages/more/in_app_web_view_page.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';
import 'package:campus_app/utils/constants.dart';

class CampusWallet extends StatelessWidget {
  const CampusWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double initialWalletOffset = (MediaQuery.of(context).size.width - 325) / 2;
    const double initialWalletOffsetTablet = (550 - 325) / 2;

    return StackedCardCarousel(
      cardAlignment: CardAlignment.center,
      scrollDirection: Axis.horizontal,
      initialOffset: MediaQuery.of(context).size.shortestSide < 600 ? initialWalletOffset : initialWalletOffsetTablet,
      spaceBetweenItems: MediaQuery.of(context).size.shortestSide < 600 ? 400 : 500,
      items: const [
        SizedBox(width: 325, height: 217, child: BogestraTicket()),
      ],
    );
  }
}

class BogestraTicket extends StatefulWidget {
  const BogestraTicket({Key? key}) : super(key: key);

  @override
  State<BogestraTicket> createState() => _BogestraTicketState();
}

class _BogestraTicketState extends State<BogestraTicket> with AutomaticKeepAliveClientMixin<BogestraTicket> {
  bool scanned = false;
  String scannedValue = '';

  late Image semesterTicketImage;
  late Image qrCodeImage;

  bool showQrCode = false;

  /// Loads the previously saved image of the semester ticket and
  /// the corresponding aztec-code
  Future<void> loadTicket() async {
    debugPrint('Loading semester ticket');

    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Define the image files
    final File ticketFile = File('$directoryPath/ticket.pdf');

    // If the images were parsed and saved in the past, they're loaded
    final bool tickedSaved = ticketFile.existsSync();
    if (tickedSaved) {
      final Image semesterTicketImage = await renderSemesterTicket(ticketFile.path);
      final Image qrCodeImage = await renderQRCode(ticketFile.path);

      setState(() {
        scanned = true;
        this.semesterTicketImage = semesterTicketImage;
        this.qrCodeImage = qrCodeImage;
      });
    }
  }

  /// Saves a loaded semester ticket and its corresponding aztec-code
  Future<void> saveTicketPDF(File ticketPdf) async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    // Save the given pdf file to the apps directory
    await ticketPdf.copy('$directoryPath/ticket.pdf');
  }

  Future<Image> renderSemesterTicket(String path) async {
    final pdf = PdfImageRendererPdf(path: path);

    await pdf.open();
    await pdf.openPage(pageIndex: 0);

    final size = await pdf.getPageSize(pageIndex: 0);

    final bytes = await pdf.renderPage(
      x: 71,
      y: 66,
      width: size.width - 353,
      height: size.height - 690,
      scale: 4,
    );

    await pdf.closePage(pageIndex: 0);
    await pdf.close();

    if (bytes == null) {
      return Image(image: MemoryImage(Uint8List.fromList([0])));
    }

    return Image(image: MemoryImage(bytes));
  }

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

    return Image(image: MemoryImage(pageImage.bytes));
  }

  Future<void> addTicket() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => InAppWebViewPage(url: rideTicketing)));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    loadTicket();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      decoration: BoxDecoration(
        color: scanned ? Colors.white : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: scanned
          ? GestureDetector(
              onTap: () {
                if (Provider.of<SettingsHandler>(context, listen: false).currentSettings.displayFullscreenTicket) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BogestraTicketFullScreen(),
                    ),
                  );
                } else {
                  setState(() => showQrCode = !showQrCode);
                  if (showQrCode) {
                    setBrightness(1);
                  } else {
                    resetBrightness();
                  }
                }
              },
              onLongPress: addTicket,
              child: showQrCode ? qrCodeImage : semesterTicketImage,
            )
          : CustomButton(
              tapHandler: addTicket,
              splashColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(0, 0, 0, 0.04)
                  : const Color.fromRGBO(255, 255, 255, 0.06),
              highlightColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(0, 0, 0, 0.02)
                  : const Color.fromRGBO(255, 255, 255, 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/img/icons/file-plus.svg',
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Füge dein Semesterticket hinzu',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
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
