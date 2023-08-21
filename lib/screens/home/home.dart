import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/home/main_page/main_page.dart';
import 'package:grocery_scanner/screens/home/profile/profile.dart';
import 'package:grocery_scanner/screens/home/scanner/scanner.dart';
import 'package:grocery_scanner/services/auth.dart';
import 'package:grocery_scanner/services/database.dart';
import 'package:grocery_scanner/shared/loading.dart';
import 'package:provider/provider.dart';
import '../../shared/colors.dart';

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
    CollectionReference users = DatabaseService(user.uid).userCollection;

    return FutureBuilder(
      future: users.doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Cos poszlo nie tak");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Dokument nie istnieje");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        UserData loggedUser = UserData.fromJson(data);

        // return Text("${loggedUser.username}\n${loggedUser.rank}");
        return Scaffold(
            backgroundColor: greyBg,
            // appBar: AppBar(
            //   title: const Text("Strona główna"),
            //   backgroundColor: green,
            //   actions: [
            //     IconButton(
            //         onPressed: () async => await _auth.signOut(),
            //         icon: const Icon(Icons.logout))
            //   ],
            // ),
            // body: Center(
            //     child: Column(
            //   children: [Text(loggedUser.username), Text(loggedUser.rank)],
            // ))
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: green,
              selectedIconTheme: const IconThemeData(size: 28),
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "Strona główna"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.scanner), label: "Skanuj"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Twój profil")
              ],
              currentIndex: _selectedIndex,
              onTap: (value) => setState(() {
                _selectedIndex = value;
              }),
            ),
            // body: _pages.elementAt(_selectedIndex),
            body: SafeArea(
              child: Center(
                  child: Column(
                children: [
                  const Text("ZALOGOWANO"),
                  Text("Login: ${loggedUser.username}"),
                  Text("Ranga: ${loggedUser.rank}"),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async => await _auth.signOut(),
                          icon: const Icon(Icons.logout)),
                      const Text("Wyloguj się")
                    ],
                  )
                ],
              )),
            ));
      },
    );

    // return StreamBuilder<UserData>(
    //     stream: DatabaseService(user.uid).userData,
    //     builder: (context, snapshot) {
    //       print(DatabaseService(user.uid).userData);
    //       return Text("a");

    //       // if (snapshot.connectionState == ConnectionState.waiting) {
    //       //   return const Loading();
    //       // }
    //       // if (snapshot.hasData) {
    //       //   UserData userData = snapshot.data!;
    //       //   return Scaffold(
    //       //     backgroundColor: greyBg,
    //       //     appBar: AppBar(
    //       //       title: const Text("Strona główna"),
    //       //       backgroundColor: green,
    //       //       actions: [
    //       //         IconButton(
    //       //             onPressed: () async => await _auth.signOut(),
    //       //             icon: const Icon(Icons.logout))
    //       //       ],
    //       //     ),
    //       //     body: Center(
    //       //         child: Column(
    //       //       children: [Text(userData.username), Text(userData.rank)],
    //       //     )),
    //       //   );
    //       // } else {
    //       //   return const Text("cos sie zjebalo");
    //       // }
    //     });
  }
}
