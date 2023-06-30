import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/auth_listener.dart';
import 'package:grocery_scanner/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  // Firebase Initializer
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamProvider for Listening Auth Changes
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: const MaterialApp(
        home: AuthListener(),
      ),
    );
  }
}
