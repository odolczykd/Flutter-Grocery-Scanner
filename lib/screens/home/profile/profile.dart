import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_button.dart';
import 'package:grocery_scanner/screens/home/profile/shared/preferences_list.dart';
import 'package:grocery_scanner/screens/home/profile/shared/rank_dialog_content.dart';
import 'package:grocery_scanner/services/auth.dart';
import 'package:grocery_scanner/services/database.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/label_row.dart';
import 'package:grocery_scanner/shared/loading.dart';
import 'package:grocery_scanner/shared/rank.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

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

        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: Column(
                children: [
                  Row(children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/kolczyk.png"),
                      radius: 40.0,
                    ),
                    const SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(loggedUser.username,
                            style: const TextStyle(
                                color: black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold)),
                        // Rank Row
                        TextButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Rangi",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              content: const RankDialogContent(),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                      foregroundColor: black),
                                  child: const Text("OK"),
                                )
                              ],
                            ),
                          ),
                          style: TextButton.styleFrom(foregroundColor: black),
                          child: Row(
                            children: [
                              rankIcon(loggedUser.rank),
                              const SizedBox(width: 5.0),
                              Text(convertRank(loggedUser.rank),
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 5.0),
                              const Icon(
                                Icons.info_outline,
                                color: grey,
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ]),
                  const SizedBox(height: 25.0),
                  LabelRow(
                      icon: Icons.kebab_dining,
                      labelText: "Twoje preferencje",
                      color: green,
                      isSecondaryIconEnabled: true,
                      secondaryIcon: Icons.edit,
                      onTap: () {}),
                  PreferencesList(list: loggedUser.preferences),
                  const SizedBox(height: 15.0),
                  LabelRow(
                      icon: Icons.no_meals,
                      labelText: "Ograniczenia i uczulenia",
                      color: green,
                      isSecondaryIconEnabled: true,
                      secondaryIcon: Icons.edit,
                      onTap: () {}),
                  PreferencesList(list: [
                    "orzechy",
                    "nabiał",
                    "jaja",
                    "ryby",
                    "skorupiaki"
                  ]),
                  const SizedBox(height: 15.0),
                  LabelRow(
                      icon: Icons.person_add,
                      labelText: "Produkty dodane przez Ciebie",
                      color: green,
                      isSecondaryIconEnabled: false,
                      secondaryIcon: Icons.edit,
                      onTap: () {}),
                  const SizedBox(height: 25.0),
                  HorizontalButton(
                      icon: Icons.edit,
                      label: "Edytuj profil",
                      color: green,
                      onPressed: () {}),
                  HorizontalButton(
                      icon: Icons.logout,
                      label: "Wyloguj się",
                      color: green,
                      onPressed: () async => await _auth.signOut())
                ],
              )),
            ),
          ),
        );
      },
    );
  }
}
