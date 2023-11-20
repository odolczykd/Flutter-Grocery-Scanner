import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/product/product_fetcher_local.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User?>(context)!;
    
    return MobileScanner(
      fit: BoxFit.fill,
      controller: MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: false,
          returnImage: true,
          detectionSpeed: DetectionSpeed.normal),
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          final barcode = barcodes[0].rawValue;
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductFetcherLocal(barcode!)));
        }
      },
    );
  }
}
