import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:pdfx/pdfx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sync_pdf;

import 'package:campus_app/core/themes.dart';

class TramTicket extends StatefulWidget {
  const TramTicket({Key? key}) : super(key: key);

  @override
  State<TramTicket> createState() => TramTicketState();
}

class TramTicketState extends State<TramTicket> {
  bool scanned = false;
  String scannedValue = '';
  late Image semesterTicketImage, qrCodeImage;

  @override
  void initState() {
    super.initState();
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
        cropRect: Rect.fromLTWH(174, 250, page.width - 325, 269));
    await page.close();

    if (pageImage == null) {
      return Image(image: MemoryImage(Uint8List.fromList([0])));
    }

    return Image(image: MemoryImage(pageImage.bytes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: !scanned
            ? MaterialButton(
                child: const Text('Press'),
                onPressed: () async {
                  final FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    final File file = File(result.files.single.path!);

                    // Load the pdf file
                    final sync_pdf.PdfDocument document = sync_pdf.PdfDocument(
                      inputBytes: await file.readAsBytes(),
                    );

                    // Get the pdf text
                    final String pdfText = sync_pdf.PdfTextExtractor(document)
                        .extractText(startPageIndex: 0);

                    // Remove the pdf file from memory for efficiency reasons
                    document.dispose();

                    // Check if the pdf file is a valid ticket
                    if (!pdfText
                        .contains('Dieses Ticket ist nicht übertragbar')) {
                      // Display error
                      return;
                    }

                    final Image semesterTicketImage =
                        await renderSemesterTicket(file.path);
                    final Image qrCodeImage = await renderQRCode(file.path);

                    setState(() {
                      scanned = true;
                      this.semesterTicketImage = semesterTicketImage;
                      this.qrCodeImage = qrCodeImage;
                    });
                  } else {
                    // User canceled the picker
                  }
                },
              )
            : semesterTicketImage,
      ),
    );
  }
}
