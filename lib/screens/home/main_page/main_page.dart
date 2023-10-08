import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:provider/provider.dart';

import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/services/database.dart';
// import 'package:grocery_scanner/services/auth.dart';
import 'package:grocery_scanner/shared/loading.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final AuthService _auth = AuthService();

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

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Center(
                child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/kolczyk.png"),
                      radius: 25.0,
                    ),
                    const SizedBox(width: 15.0),
                    Text("Cześć, ${loggedUser.username}!",
                        style: const TextStyle(
                            color: black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 30.0),
                const Row(
                  children: [
                    Icon(Icons.update, color: green),
                    SizedBox(width: 5.0),
                    Text(
                      "Ostatnio skanowane produkty",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SingleChildScrollView(
                    // TODO: child: Lista kafelków
                    ),
                const Row(
                  children: [
                    Icon(Icons.push_pin, color: green),
                    SizedBox(width: 5.0),
                    Text(
                      "Przypięte produkty",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SingleChildScrollView(
                    // TODO: child: Lista kafelków
                    ),
                const Row(
                  children: [
                    Icon(Icons.person_add_alt_1, color: green),
                    SizedBox(width: 5.0),
                    Text(
                      "Produkty dodane przez Ciebie",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SingleChildScrollView(
                    // TODO: child: Lista kafelków
                    ),
              ],
            )),
          )),
        );

        // return SafeArea(
        //   child: Center(
        //       child: Column(
        //     children: [
        //       const Text("ZALOGOWANOU"),
        //       Text("Login: ${loggedUser.username}"),
        //       Text("Ranga: ${loggedUser.rank}"),
        //       Row(
        //         children: [
        //           IconButton(
        //               onPressed: () async => await _auth.signOut(),
        //               icon: const Icon(Icons.logout)),
        //           const Text("Wyloguj się")
        //         ],
        //       )
        //     ],
        //   )),
        // );
      },
    );

    // return const Center(child: Text("Strona główna"));
  }
}
