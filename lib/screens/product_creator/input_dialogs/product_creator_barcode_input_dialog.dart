import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';

class ProductCreatorBarcodeInputDialog extends StatefulWidget {
  final String initValue;
  final Function(String) setValue;

  const ProductCreatorBarcodeInputDialog(
      {super.key, required this.initValue, required this.setValue});

  @override
  State<ProductCreatorBarcodeInputDialog> createState() =>
      _ProductCreatorBarcodeInputDialogState();
}

class _ProductCreatorBarcodeInputDialogState
    extends State<ProductCreatorBarcodeInputDialog> {
  String input = "";
  String validatorMsg = "";

  @override
  void initState() {
    super.initState();
    input = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edytuj kod kreskowy",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      content: IntrinsicHeight(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormTextField(
                labelText: "Kod kreskowy",
                color: green,
                obscureText: false,
                callback: (val) => input = val,
                validator: (val) => null,
                // validator: (val) {
                //   if (val!.isEmpty) {
                //     return "To pole nie może być puste";
                //   } else if (!RegExp(r"^[0-9]+$")
                //       .hasMatch(val)) {
                //     return "Kod kreskowy może zawierać wyłącznie cyfry";
                //   } else if (!(val.length == 8 ||
                //       val.length == 13)) {
                //     return "Kod kreskowy musi mieć 8 lub 13 cyfr";
                //   } else {
                //     return null;
                //   }
                // },
                value: widget.initValue,
              ),
              const SizedBox(height: 10),
              if (validatorMsg.isNotEmpty)
                Text(validatorMsg, style: const TextStyle(color: red))
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            validatorMsg = "";
            if (input.isEmpty) {
              setState(() => validatorMsg = "To pole nie może być puste");
            } else if (!RegExp(r"^[0-9]+$").hasMatch(input)) {
              setState(() =>
                  validatorMsg = "Kod kreskowy może zawierać wyłącznie cyfry");
            } else if (!(input.length == 8 || input.length == 13)) {
              setState(
                  () => validatorMsg = "Kod kreskowy musi mieć 8 lub 13 cyfr");
            } else {
              // setState(() => barcode = input);
              widget.setValue(input);
              Navigator.pop(context);
            }
          },
          style: TextButton.styleFrom(foregroundColor: black),
          child: const Text("OK"),
        )
      ],
    );
  }
}
