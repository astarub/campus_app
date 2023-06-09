import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:campus_app/utils/widgets/campus_icon_button.dart';

class BarcodeScanner extends StatefulWidget {
  final Function(BarcodeCapture) onBarcodeDetected;
  final VoidCallback onBack;

  const BarcodeScanner({
    Key? key,
    required this.onBarcodeDetected,
    required this.onBack,
  }) : super(key: key);

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Barcode scanner
        Container(
          height: 120,
          padding: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: MobileScanner(
            controller: MobileScannerController(formats: [BarcodeFormat.code128]),
            onDetect: widget.onBarcodeDetected,
          ),
        ),
        // Back button
        CampusIconButton(
          iconPath: 'assets/img/icons/arrow-left.svg',
          onTap: widget.onBack,
        ),
      ],
    );
  }
}
