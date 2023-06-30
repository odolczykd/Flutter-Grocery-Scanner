import 'package:flutter/material.dart';
import 'package:grocery_scanner/services/auth.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Strona główna"),
        backgroundColor: Colors.green[400],
        actions: [
          IconButton(
              onPressed: () async => await _auth.signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
