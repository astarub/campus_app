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

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/guide/widgets/stacked_card_carousel.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

class CampusWallet extends StatelessWidget {
  const CampusWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StackedCardCarousel(
      scrollDirection: Axis.horizontal,
      items: [
        Container(
          width: 300,
          height: 200,
          child: const BogestraTicket(),
        ),
        Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
          ),
          child: Center(
            child: Text('2'),
          ),
        ),
        Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
          ),
          child: Center(
            child: Text('3'),
          ),
        ),
      ],
    );
  }
}

class BogestraTicket extends StatefulWidget {
  /* Image? semesterTicketImage;
  Image? qrCodeImage; */

  const BogestraTicket({Key? key}) : super(key: key);

  @override
  State<BogestraTicket> createState() => _BogestraTicketState();
}

class _BogestraTicketState extends State<BogestraTicket> with AutomaticKeepAliveClientMixin<BogestraTicket> {
  bool scanned = false;
  String scannedValue = '';

  late Image semesterTicketImage;
  late Image qrCodeImage;

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: scanned
          ? Container(
              child: semesterTicketImage,
            )
          : CustomButton(
              tapHandler: addTicket,
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
