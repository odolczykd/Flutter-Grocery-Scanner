import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/auth/shared/login_register_text_field.dart';
import 'package:grocery_scanner/services/auth.dart';
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
  String email = "";
  String password = "";
  String passwordConfirm = "";

  String formErrorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              formErrorMessage,
              style: const TextStyle(color: red, fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            LoginRegisterTextField(
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
                  }
                  // else if (login jest juz zajety) {
                  //   return "Nazwa użytkownika jest zajęta";
                  // }
                  else {
                    return null;
                  }
                }),
            const SizedBox(height: 10.0),
            LoginRegisterTextField(
              callback: (val) => setState(() => email = val),
              labelText: "Adres e-mail",
              color: orange,
              obscureText: false,
              validator: (val) => !EmailValidator.validate(val!)
                  ? "Wprowadź poprawny adres e-mail"
                  : null,
            ),
            const SizedBox(height: 10.0),
            LoginRegisterTextField(
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
            const SizedBox(height: 10.0),
            LoginRegisterTextField(
                labelText: "Powtórz hasło",
                color: orange,
                obscureText: true,
                validator: (val) =>
                    password != val ? "Hasła się nie zgadzają" : null),
            const SizedBox(height: 25.0),
            FilledButton(
              onPressed: () async {
                // Form Validation
                if (_formKey.currentState!.validate()) {
                  dynamic result = _auth.register(username, email, password);
                  if (result == null) {
                    setState(() => formErrorMessage =
                        "Rejestracja nie powiodła się! Spróbuj ponownie później.");
                  }
                }
              },
              style: ButtonStyle(
                  elevation: const MaterialStatePropertyAll(0.0),
                  backgroundColor: const MaterialStatePropertyAll(orange),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)))),
              child: const Text(
                "ZAŁÓŻ KONTO",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ));
  }
}
