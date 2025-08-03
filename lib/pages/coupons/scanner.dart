import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR-Code scannen')),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isScanned) return;

          final String? code = capture.barcodes.first.rawValue;
          if (code != null) {
            setState(() {
              _isScanned = true;
            });
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}
