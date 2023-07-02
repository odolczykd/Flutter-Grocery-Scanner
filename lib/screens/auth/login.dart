import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_scanner/screens/auth/shared/login_register_text_field.dart';
import 'package:grocery_scanner/services/auth.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();

  // Colors
  static const Color green = Color(0xFF4FB000);

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        const LoginRegisterTextField(
            labelText: "Login lub adres e-mail",
            color: green,
            obscureText: false),
        const SizedBox(height: 10.0),
        const LoginRegisterTextField(
            labelText: "Hasło", color: green, obscureText: true),
        const SizedBox(height: 25.0),
        FilledButton(
          onPressed: () {},
          style: ButtonStyle(
              elevation: const MaterialStatePropertyAll(0.0),
              backgroundColor: const MaterialStatePropertyAll(green),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)))),
          child: const Text(
            "ZALOGUJ",
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    ));
  }
}
