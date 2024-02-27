import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_filled_button.dart';
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
  String displayName = "";
  String email = "";
  String password = "";
  String passwordConfirm = "";

  String formErrorMessage = "";
  bool isUsernameOccupied = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
              } else if (val.length > 24) {
                return "Imię może mieć maksymalnie 24 znaki";
              } else {
                return null;
              }
            },
          ),

          // Email Address
          const SizedBox(height: 10),
          FormTextField(
            callback: (val) => setState(() => email = val),
            labelText: "Adres e-mail",
            color: orange,
            obscureText: false,
            validator: (val) {
              if (!EmailValidator.validate(val!)) {
                return "Wprowadź poprawny adres e-mail";
              } else if (val.length > 36) {
                return "Adres e-mail może mieć maksymalnie 36 znaków";
              } else {
                return null;
              }
            },
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
            },
          ),

          // Password Confirm
          const SizedBox(height: 10),
          FormTextField(
            labelText: "Powtórz hasło",
            color: orange,
            obscureText: true,
            validator: (val) {
              if (val!.isEmpty || password != val) {
                return "Hasła się nie zgadzają";
              } else {
                return null;
              }
            },
          ),

          // Form Errors
          const SizedBox(height: 10),
          Text(
            formErrorMessage,
            style: const TextStyle(color: red, fontSize: 16),
          ),

          // Register Button
          const SizedBox(height: 10),
          HorizontalFilledButton(
            label: "Załóż konto",
            color: orange,
            onPressed: () async {
              // Form Validation
              if (_formKey.currentState!.validate()) {
                var result = await _auth.register(displayName, email, password);

                if (result == null) {
                  Fluttertoast.showToast(
                    msg: "Coś poszło nie tak... Spróbuj ponownie później",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Pomyślnie założono konto",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16,
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
