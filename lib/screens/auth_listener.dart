import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/auth/auth.dart';
import 'package:grocery_scanner/screens/home/home.dart';
import 'package:provider/provider.dart';

class AuthListener extends StatelessWidget {
  const AuthListener({super.key});

  @override
  Widget build(BuildContext context) {
    // Render either Auth or Home Screen based on received Provider
    final user = Provider.of<User?>(context);
    return user == null ? const Auth() : const Home();
  }
}
