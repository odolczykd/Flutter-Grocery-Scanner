import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_button.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_filled_button.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';
import 'package:grocery_scanner/services/auth_service.dart';
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
    return isLoading
        ? const Loading()
        : Form(
            key: _formKey,
            child: Column(
              children: [
                // Email Address
                const SizedBox(height: 20),
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
                  },
                ),

                // Password
                const SizedBox(height: 10),
                FormTextField(
                  callback: (val) => setState(() => password = val),
                  labelText: "Hasło",
                  color: green,
                  obscureText: true,
                  validator: (val) => val!.isEmpty ? "Wprowadź hasło" : null,
                ),

                // Form Errors
                const SizedBox(height: 10),
                Text(
                  formErrorMessage,
                  style: const TextStyle(color: red, fontSize: 16),
                ),

                // Login Button
                const SizedBox(height: 10),
                HorizontalFilledButton(
                  label: "Zaloguj się",
                  color: green,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => isLoading = true);
                      dynamic result = await _auth.signIn(email, password);

                      if (result == "user-not-found" ||
                          result == "invalid-email" ||
                          result == "wrong-password") {
                        setState(
                          () {
                            formErrorMessage = "Błędny adres e-mail lub hasło";
                            isLoading = false;
                          },
                        );
                      }

                      if (result == null) {
                        Fluttertoast.showToast(
                          msg: "Coś poszło nie tak... Spróbuj ponownie później",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 16,
                        );
                      }
                    }
                  },
                ),

                // Quick Scan Mode Button
                const SizedBox(height: 30),
                const Divider(
                  color: greyButton,
                  thickness: 3,
                ),
                const SizedBox(height: 30),
                HorizontalButton(
                  icon: Icons.barcode_reader,
                  label: "Tryb szybkiego skanowania",
                  color: green,
                  onPressed: () => Navigator.of(context).pushNamed("/scanner"),
                )
              ],
            ),
          );
  }
}
