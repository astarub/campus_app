import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:pdfx/pdfx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sync_pdf;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:barcode_widget/barcode_widget.dart' as bw;

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/guide/widgets/stacked_card_carousel.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';
import 'package:campus_app/pages/guide/widgets/barcode_scanner.dart';

class CampusWallet extends StatelessWidget {
  const CampusWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double initialWalletOffset = (MediaQuery.of(context).size.width - 300) / 2;

    return StackedCardCarousel(
      scrollDirection: Axis.horizontal,
      initialOffset: initialWalletOffset,
      items: const [
        SizedBox(width: 300, height: 200, child: BogestraTicket()),
        SizedBox(width: 300, height: 200, child: UbCard()),
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
    final bool tickedSaved = await ticketFile.exists();
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
        width: page.width * 2.4, height: page.height * 2.4, cropRect: Rect.fromLTWH(174, 250, page.width - 325, 269));
    await page.close();

    if (pageImage == null) {
      return Image(image: MemoryImage(Uint8List.fromList([0])));
    }

    return Image(image: MemoryImage(pageImage.bytes));
  }

  Future<void> addTicket() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final File file = File(result.files.single.path!);

      // Load the pdf file
      final sync_pdf.PdfDocument document = sync_pdf.PdfDocument(inputBytes: await file.readAsBytes());

      // Get the pdf text
      final String pdfText = sync_pdf.PdfTextExtractor(document).extractText(startPageIndex: 0);

      // Remove the pdf file from memory for efficiency reasons
      document.dispose();

      // Check if the pdf file is a valid ticket
      if (!pdfText.contains('Dieses Ticket ist nicht übertragbar')) {
        // Display error
        return;
      }

      // Save the picked pdf file
      unawaited(saveTicketPDF(file));

      // Parse the picked pdf
      final Image semesterTicketImage = await renderSemesterTicket(file.path);
      final Image qrCodeImage = await renderQRCode(file.path);

      setState(() {
        scanned = true;
        this.semesterTicketImage = semesterTicketImage;
        this.qrCodeImage = qrCodeImage;
      });
    } else {
      // User canceled the picker
    }
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: scanned
          ? GestureDetector(
              onTap: () {
                setState(() => showQrCode = !showQrCode);
                if (showQrCode) {
                  setBrightness(1);
                } else {
                  resetBrightness();
                }
              },
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
                    color: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.color,
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

class UbCard extends StatefulWidget {
  const UbCard({Key? key}) : super(key: key);

  @override
  State<UbCard> createState() => _UbCardState();
}

class _UbCardState extends State<UbCard> with AutomaticKeepAliveClientMixin<UbCard> {
  bool scanned = false;
  String scannedValue = '';
  bool error = false;

  bool showScanner = false;
  bool showCode = false;

  /// Scans the UB barcode
  void addBarcode(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes[0].type == BarcodeType.text || barcodes[0].rawValue != null) {
      if (barcodes[0].rawValue!.startsWith('1080')) {
        setState(() {
          scannedValue = barcodes[0].rawValue!;
          scanned = true;
          showScanner = false;
        });
        safeBarcode();
      } else {
        setState(() => error = true);
      }
    } else {
      setState(() => error = true);
    }
  }

  /// Save the given barcode to the apps directory
  Future<void> safeBarcode() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    final File barcodeFile = File('$directoryPath/settings.txt');
    barcodeFile.writeAsString(scannedValue);

    debugPrint('Saved UB barcode.');
  }

  /// Load the previsouly scanned barcode
  Future<void> loadBarcode() async {
    final Directory saveDirectory = await getApplicationDocumentsDirectory();
    final String directoryPath = saveDirectory.path;

    final File barcodeFile = File('$directoryPath/settings.txt');

    await barcodeFile.exists().then((bool existing) {
      if (existing) {
        debugPrint('Loading UB barcode');

        barcodeFile.readAsString().then((String loadedValue) {
          if (loadedValue != '') {
            setState(() {
              scannedValue = loadedValue;
              scanned = true;
            });
          }
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    loadBarcode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: showScanner
          ? BarcodeScanner(
              onBarcodeDetected: addBarcode,
              onBack: () {
                setState(() => showScanner = false);
              },
            )
          : scanned
              ? GestureDetector(
                  onTap: () {
                    setState(() => showCode = !showCode);
                    if (showCode) {
                      setBrightness(1);
                    } else {
                      resetBrightness();
                    }
                  },
                  child: SizedBox(
                    height: 95,
                    width: 320,
                    child: Center(
                      child: bw.BarcodeWidget(
                        data: scannedValue,
                        barcode: bw.Barcode.code128(),
                        height: 95,
                        width: 320,
                        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                            ? Colors.black
                            : Colors.white,
                        backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 3,
                          left: 12,
                          right: 12,
                        ),
                      ),
                    ),
                  ),
                )
              : CustomButton(
                  tapHandler: () {
                    setState(() => showScanner = true);
                  },
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
                        color: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.color,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Füge deinen UB Ausweis hinzu',
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
    print(e);
    throw 'Failed to set brightness';
  }
}

Future<void> resetBrightness() async {
  try {
    await ScreenBrightness().resetScreenBrightness();
  } catch (e) {
    print(e);
    throw 'Failed to reset brightness';
  }
}
