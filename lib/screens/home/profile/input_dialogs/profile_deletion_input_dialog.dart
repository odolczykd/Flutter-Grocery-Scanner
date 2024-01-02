import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_scanner/services/auth_service.dart';
import 'package:grocery_scanner/services/user_database_service.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';

class ProfileDeletionInputDialog extends StatefulWidget {
  const ProfileDeletionInputDialog({super.key});

  @override
  State<ProfileDeletionInputDialog> createState() =>
      _ProfileDeletionInputDialogState();
}

class _ProfileDeletionInputDialogState
    extends State<ProfileDeletionInputDialog> {
  final AuthService _auth = AuthService();

  String email = "";
  String password = "";

  String validatorMsg = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Usuń konto",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      content: IntrinsicHeight(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              FormTextField(
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
                  }),
              const SizedBox(height: 10),
              FormTextField(
                callback: (val) => setState(() => password = val),
                labelText: "Hasło",
                color: green,
                obscureText: true,
                validator: (val) => val!.isEmpty ? "Wprowadź hasło" : null,
              )
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
              await UserDatabaseService(_auth.currentUserUid!).deleteDocument();
              bool result = await _auth.deleteAccount(email, password);
              if (result) {
                Fluttertoast.showToast(
                    msg: "Konto zostało usunięte",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16);
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/");
              } else {
                Fluttertoast.showToast(
                    msg:
                        "Coś poszło nie tak... Sprawdź, czy wprowadzone dane są poprawne",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16);
              }
            },
            style: TextButton.styleFrom(foregroundColor: black),
            child: const Text("USUŃ KONTO", style: TextStyle(color: red)))
      ],
    );
  }
}
