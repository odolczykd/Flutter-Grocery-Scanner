import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/product_page/product_fetcher_database.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  @override
  Widget build(BuildContext context) => MobileScanner(
        fit: BoxFit.cover,
        controller: MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: false,
          detectionSpeed: DetectionSpeed.normal,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final barcode = barcodes[0].rawValue;
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductFetcherDatabase(barcode!),
              ),
            );
          }
        },
      );
}
