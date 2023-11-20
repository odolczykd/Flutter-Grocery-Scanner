import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/auth_listener.dart';
import 'package:grocery_scanner/screens/home/home.dart';
import 'package:grocery_scanner/screens/home/main_page/main_page.dart';
import 'package:grocery_scanner/screens/home/profile/profile.dart';
import 'package:grocery_scanner/screens/home/scanner/scanner.dart';
import 'package:grocery_scanner/screens/product/product_creator/product_creator.dart';
import 'package:grocery_scanner/screens/product/product_fetcher_api.dart';
import 'package:grocery_scanner/screens/product/product_not_found.dart';
import 'package:grocery_scanner/screens/product/product_page.dart';
import 'package:grocery_scanner/screens/product/product_fetcher_local.dart';
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
      child: MaterialApp(
          title: "Grocery Scanner",
          initialRoute: "/",
          routes: {
            "/": (context) => const AuthListener(),
            "/home": (context) => const Home(),
            "/main": (context) => const MainPage(),
            "/scanner": (context) => const Scanner(),
            "/profile": (context) => const Profile()
          },
          // home: AuthListener(),
          // home: Product(),
          // home: ProductCreator(),
          // home: ProductController("5900385000815")
          // home: ProductFetcherLocal("5900512990095")
          // home: ProductFetcherLocal("8714100666920")
          // home: ProductFetcherLocal("5900385000815")
          // home: ProductFetcherLocal("5900820011529")
          // home: ProductController(null)
          ),
    );
  }
}
