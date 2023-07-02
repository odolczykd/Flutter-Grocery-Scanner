import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/auth/shared/login_register_text_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  static const Color orange = Color(0xFFEF6C00);

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        const LoginRegisterTextField(
            labelText: "Imię", color: orange, obscureText: false),
        const SizedBox(height: 10.0),
        const LoginRegisterTextField(
            labelText: "Nazwisko", color: orange, obscureText: false),
        const SizedBox(height: 10.0),
        const LoginRegisterTextField(
            labelText: "Nazwa użytkownika", color: orange, obscureText: false),
        const SizedBox(height: 10.0),
        const LoginRegisterTextField(
            labelText: "Adres e-mail", color: orange, obscureText: false),
        const SizedBox(height: 10.0),
        const LoginRegisterTextField(
            labelText: "Hasło", color: orange, obscureText: true),
        const SizedBox(height: 10.0),
        const LoginRegisterTextField(
            labelText: "Powtórz hasło", color: orange, obscureText: true),
        const SizedBox(height: 25.0),
        FilledButton(
          onPressed: () {},
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
