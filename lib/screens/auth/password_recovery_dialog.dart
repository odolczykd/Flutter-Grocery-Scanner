// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_scanner/services/auth_service.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';

class PasswordRecoveryDialog extends StatefulWidget {
  const PasswordRecoveryDialog({super.key});

  @override
  State<PasswordRecoveryDialog> createState() => _PasswordRecoveryDialogState();
}

class _PasswordRecoveryDialogState extends State<PasswordRecoveryDialog> {
  final _formKey = GlobalKey<FormState>();
  String email = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Zresetuj hasło",
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
              const Text(
                  "Wprowadź adres e-mail, na który zostało założone konto w aplikacji Grocery Scanner. Na podany adres zostaną wysłane dalsze instrukcje resetowania hasła."),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: FormTextField(
                  callback: (val) => setState(() => email = val),
                  labelText: "Adres e-mail",
                  color: green,
                  obscureText: false,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Wprowadź adres e-mail";
                    } else if (!EmailValidator.validate(val)) {
                      return "Wprowadź poprawny adres e-mail";
                    } else {
                      return null;
                    }
                  },
                ),
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              bool result = await AuthService().sendPasswordResetEmail(email);

              if (result) {
                Fluttertoast.showToast(
                  msg: "Wysłano wiadomość na podany adres e-mail",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  fontSize: 16,
                );
                Navigator.of(context).pop();
              } else {
                Fluttertoast.showToast(
                  msg: "Coś poszło nie tak...",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  fontSize: 16,
                );
              }
            }
          },
          style: TextButton.styleFrom(foregroundColor: black),
          child: const Text(
            "WYŚLIJ E-MAIL",
            style: TextStyle(color: green),
          ),
        ),
      ],
    );
  }
}
