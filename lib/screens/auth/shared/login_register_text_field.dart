import 'package:flutter/material.dart';

class LoginRegisterTextField extends StatelessWidget {
  final String labelText;
  final Color color;
  final bool obscureText;

  const LoginRegisterTextField(
      {super.key,
      required this.labelText,
      required this.color,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Colors.grey,
        labelText: labelText,
        contentPadding: const EdgeInsets.all(15.0),
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color, width: 2.0),
            borderRadius: BorderRadius.circular(10.0)),
        focusColor: color,
      ),
      onChanged: (value) {},
    );
  }
}
