import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_button.dart';
import 'package:grocery_scanner/screens/product/product.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  // final _barcodeResultErrorRegex = RegExp(r'^\(\(.*\)\)$');

  String _barcode = "";

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      fit: BoxFit.fill,
      controller: MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: false,
          returnImage: true,
          detectionSpeed: DetectionSpeed.noDuplicates),
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Product(
                    barcode: barcodes[0].rawValue,
                  )));
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: greyBg,
  //     body: SafeArea(
  //       child: Padding(
  //         padding: const EdgeInsets.all(30.0),
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               const Icon(
  //                 Icons.qr_code_scanner,
  //                 size: 80,
  //                 color: green,
  //               ),
  //               const SizedBox(height: 15),
  //               const Text("Skanuj produkt",
  //                   style:
  //                       TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
  //               const SizedBox(height: 30),
  //               const Text(
  //                 "Zeskanuj kod kreskowy produktu znajdujący się na opakowaniu, aby uzyskać szczegółowe informacje na jego temat",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               if (_barcodeResultErrorRegex.hasMatch(_barcode))
  //                 const SizedBox(height: 50),
  //               if (_barcodeResultErrorRegex.hasMatch(_barcode))
  //                 const Text(
  //                   "Wystąpił błąd podczas skanowania! Upewnij się, że kod kreskowy jest dobrze widoczny i spróbuj ponownie",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       fontSize: 18, fontWeight: FontWeight.bold, color: red),
  //                 ),
  //               if (_barcode.isNotEmpty &&
  //                   !_barcodeResultErrorRegex.hasMatch(_barcode))
  //                 Text(
  //                   "Kod kreskowy: $_barcode",
  //                   textAlign: TextAlign.center,
  //                   style: const TextStyle(
  //                       fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //               const SizedBox(height: 30),
  //               HorizontalButton(
  //                   icon: Icons.local_dining,
  //                   label: "Uruchom skaner",
  //                   color: green,
  //                   onPressed: () {}),
  //               const SizedBox(height: 50),
  //               HorizontalButton(
  //                   icon: Icons.add_circle_outline,
  //                   label: "Dodaj nowy produkt",
  //                   color: green,
  //                   onPressed: () {}),
  //               const SizedBox(height: 10),
  //               HorizontalButton(
  //                   icon: Icons.home,
  //                   label: "Wróć na stronę główną",
  //                   color: green,
  //                   onPressed: () {})
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
