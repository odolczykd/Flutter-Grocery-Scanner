import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';
import 'package:grocery_scanner/services/auth.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/loading.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Form Field Values
  String email = "";
  String password = "";

  String formErrorMessage = "";

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? const Loading()
        : Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  formErrorMessage,
                  style: const TextStyle(color: red, fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 10.0),
                FormTextField(
                  callback: (val) => setState(() => password = val),
                  labelText: "Hasło",
                  color: green,
                  obscureText: true,
                  validator: (val) => val!.isEmpty ? "Wprowadź hasło" : null,
                ),
                const SizedBox(height: 25.0),
                FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => isLoading = true);
                      dynamic result = _auth.signIn(email, password);
                      if (result == null) {
                        setState(() {
                          formErrorMessage = "Błędny adres e-mail lub hasło";
                          isLoading = false;
                        });
                      }
                    }
                  },
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
