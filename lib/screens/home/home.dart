import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/home/main_page/main_page.dart';
import 'package:grocery_scanner/screens/home/profile/profile.dart';
import 'package:grocery_scanner/screens/home/scanner/scanner.dart';
import 'package:grocery_scanner/screens/product_page/product_page.dart';
import 'package:grocery_scanner/screens/product_creator/product_creator.dart';
import 'package:grocery_scanner/services/auth_service.dart';
import 'package:grocery_scanner/services/user_database_service.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const MainPage(),
    const Scanner(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context)!;
    CollectionReference users = UserDatabaseService(user.uid).userCollection;

    return FutureBuilder(
      future: users.doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Cos poszlo nie tak");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Dokument nie istnieje");
        }

        return Scaffold(
            backgroundColor: greyBg,
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: green,
              selectedIconTheme: const IconThemeData(size: 28),
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "Strona główna"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.barcode_reader), label: "Skanuj produkt"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Twój profil")
              ],
              currentIndex: _selectedIndex,
              onTap: (value) => setState(() => _selectedIndex = value),
            ),
            // body: Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: _pages.elementAt(_selectedIndex),
            // )
            body: _pages.elementAt(_selectedIndex)
            // body: Product(),
            // body: ProductCreator(),
            );
      },
    );
  }
}
