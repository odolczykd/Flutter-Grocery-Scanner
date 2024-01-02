import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/auth/login_register.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) => const LoginRegister();
}
