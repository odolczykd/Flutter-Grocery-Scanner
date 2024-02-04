import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';

class ProfileDisplayNameInputDialog extends StatefulWidget {
  final String initValue;
  final Function(String) setValue;

  const ProfileDisplayNameInputDialog(
      {super.key, required this.initValue, required this.setValue});

  @override
  State<ProfileDisplayNameInputDialog> createState() =>
      _ProfileDisplayNameInputDialogState();
}

class _ProfileDisplayNameInputDialogState
    extends State<ProfileDisplayNameInputDialog> {
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
      title: const Text(
        "Edytuj imię",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: IntrinsicHeight(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormTextField(
                labelText: "Imię",
                color: green,
                obscureText: false,
                callback: (val) => input = val,
                validator: (val) => null,
                value: widget.initValue,
              ),
              const SizedBox(height: 10),
              if (validatorMsg.isNotEmpty)
                Text(
                  validatorMsg,
                  style: const TextStyle(color: red),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: black),
          child: const Text("ANULUJ"),
        ),
        TextButton(
          onPressed: () {
            validatorMsg = "";
            if (input.isEmpty) {
              setState(() => validatorMsg = "To pole nie może być puste");
            } else {
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
