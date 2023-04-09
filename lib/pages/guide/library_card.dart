import 'package:barcode_widget/barcode_widget.dart' as bw;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class LibraryCard extends StatefulWidget {
  const LibraryCard({Key? key}) : super(key: key);

  @override
  State<LibraryCard> createState() => _LibraryCardState();
}

class _LibraryCardState extends State<LibraryCard> {
  bool codeFound = false;
  bool error = false;
  String value = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: codeFound
          ? Container(
              padding: const EdgeInsets.only(top: 30),
              child: bw.BarcodeWidget(
                data: value,
                barcode: bw.Barcode.code128(),
                width: 320,
                height: 95,
                backgroundColor: Colors.white,
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
            )
          : Stack(
              children: <Widget>[
                MobileScanner(
                  controller: MobileScannerController(
                    formats: [BarcodeFormat.code128],
                  ),
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;

                    if (barcodes[0].type != BarcodeType.text ||
                        barcodes[0].rawValue == null) {
                      setState(() {
                        error = true;
                      });
                      return;
                    }

                    if (!barcodes[0].rawValue!.startsWith('1080')) {
                      setState(() {
                        error = true;
                      });
                      return;
                    }

                    setState(() {
                      value = barcodes[0].rawValue!;
                      codeFound = true;
                    });
                  },
                ),
                if (error)
                  const Center(
                    child: Text(
                      'Fehler beim Scannen! Bitte wiederhole den Scanvorgang!',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
              ],
            ),
    );
  }
}
