import 'package:flutter/material.dart';
import 'package:grocery_scanner/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text("Zaloguj się"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: ElevatedButton(
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null)
              print("ERROR: Could not sign in");
            else {
              print("SUCCESS");
              print(result.uid);
            }
          },
          child: const Text("Zaloguj się anonimowo"),
        ),
      ),
    );
  }
}
