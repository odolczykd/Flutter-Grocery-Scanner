import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';
import 'package:grocery_scanner/services/auth_service.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Form Field Values
  String username = "";
  String displayName = "";
  String email = "";
  String password = "";
  String passwordConfirm = "";

  bool isUsernameOccupied = true;
  String formErrorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            // Form Errors
            Text(
              formErrorMessage,
              style: const TextStyle(color: red, fontSize: 16),
            ),

            // Username
            const SizedBox(height: 20),
            FormTextField(
                callback: (val) => setState(() => username = val),
                labelText: "Nazwa użytkownika",
                color: orange,
                obscureText: false,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Nazwa użytkownika nie może być pusta";
                  } else if (RegExp(r'[!@#<>?":`~;[\]\\|=+)(*&^%-]+')
                      .hasMatch(val)) {
                    return "Dopuszczalne znaki to litery, cyfry oraz symbol _";
                  } else {
                    return null;
                  }
                }),

            // Display Name
            const SizedBox(height: 10),
            FormTextField(
                callback: (val) => setState(() => displayName = val),
                labelText: "Imię",
                color: orange,
                obscureText: false,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Imię nie może być puste";
                  } else {
                    return null;
                  }
                }),

            // Email Address
            const SizedBox(height: 10),
            FormTextField(
              callback: (val) => setState(() => email = val),
              labelText: "Adres e-mail",
              color: orange,
              obscureText: false,
              validator: (val) => !EmailValidator.validate(val!)
                  ? "Wprowadź poprawny adres e-mail"
                  : null,
            ),

            // Password
            const SizedBox(height: 10),
            FormTextField(
                callback: (val) => setState(() => password = val),
                labelText: "Hasło",
                color: orange,
                obscureText: true,
                validator: (val) {
                  // at least 8 characters
                  // at least one capitalized letter
                  // at least one numeric character
                  if (val!.length < 8) {
                    return "Hasło powinno mieć co najmniej 8 znaków";
                  } else if (!val.contains(RegExp(r'[A-Z]'))) {
                    return "Hasło powinno mieć co najmniej jedną wielką literę";
                  } else if (!val.contains(RegExp(r'[0-9]'))) {
                    return "Hasło powinno mieć co najmniej jedną cyfrę";
                  } else {
                    return null;
                  }
                }),

            // Password Confirm
            const SizedBox(height: 10),
            FormTextField(
                labelText: "Powtórz hasło",
                color: orange,
                obscureText: true,
                validator: (val) =>
                    password != val ? "Hasła się nie zgadzają" : null),
            const SizedBox(height: 25),
            FilledButton(
              onPressed: () async {
                bool isUsernameOccupied =
                    await _checkIfUsernameIsOccupied(username);

                if (isUsernameOccupied) {
                  setState(
                      () => formErrorMessage = "Nazwa użytkownika jest zajęta");
                  return;
                }

                // Form Validation
                if (_formKey.currentState!.validate()) {
                  dynamic result =
                      _auth.register(username, displayName, email, password);
                  if (result == null) {
                    setState(() => formErrorMessage =
                        "Rejestracja nie powiodła się! Spróbuj ponownie później.");
                  }
                }
              },
              style: ButtonStyle(
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: const MaterialStatePropertyAll(orange),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
              child: const Text(
                "ZAŁÓŻ KONTO",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ));
  }

  Future<bool> _checkIfUsernameIsOccupied(String username) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    final allUsernames =
        querySnapshot.docs.map((doc) => doc.get("username")).toList();
    return allUsernames.contains(username);
  }
}
