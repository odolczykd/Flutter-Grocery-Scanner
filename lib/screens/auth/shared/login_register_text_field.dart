import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class LoginRegisterTextField extends StatelessWidget {
  final String labelText;
  final Color color;
  final bool obscureText;
  final String? Function(String?) validator;
  Function? callback;

  LoginRegisterTextField({
    super.key,
    this.callback,
    required this.labelText,
    required this.color,
    required this.obscureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      cursorColor: black,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: grey,
        labelText: labelText,
        contentPadding: const EdgeInsets.all(15.0),
        labelStyle: const TextStyle(color: grey),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: grey, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color, width: 2.0),
            borderRadius: BorderRadius.circular(10.0)),
        focusColor: color,
      ),
      onChanged: (val) => callback != null ? callback!(val) : null,
    );
  }
}
