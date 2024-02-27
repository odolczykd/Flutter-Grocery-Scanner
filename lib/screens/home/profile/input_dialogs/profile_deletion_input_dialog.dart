// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_scanner/services/auth_service.dart';
import 'package:grocery_scanner/services/user_database_service.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';

class ProfileDeletionInputDialog extends StatefulWidget {
  final String email;
  const ProfileDeletionInputDialog({super.key, required this.email});

  @override
  State<ProfileDeletionInputDialog> createState() =>
      _ProfileDeletionInputDialogState();
}

class _ProfileDeletionInputDialogState
    extends State<ProfileDeletionInputDialog> {
  final AuthService _auth = AuthService();

  String password = "";
  String validatorMsg = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Usuń konto",
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
              const Text("Aby usunąć konto, wpisz hasło."),
              const Text(
                "Pamiętaj, że proces ten jest nieodwracalny! Po kliknięciu przycisku, wszystkie dane zostaną utracone!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
            bool result = await _auth.deleteAccount(widget.email, password);
            if (result) {
              await UserDatabaseService(_auth.currentUserUid!).deleteDocument();
              Fluttertoast.showToast(
                msg: "Konto zostało usunięte",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                fontSize: 16,
              );
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/");
            } else {
              Fluttertoast.showToast(
                msg:
                    "Coś poszło nie tak... Sprawdź, czy wprowadzone dane są poprawne",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                fontSize: 16,
              );
            }
          },
          style: TextButton.styleFrom(foregroundColor: black),
          child: const Text(
            "USUŃ KONTO",
            style: TextStyle(color: red),
          ),
        ),
      ],
    );
  }
}
