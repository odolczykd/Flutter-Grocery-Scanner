// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/home/profile/input_dialogs/profile_deletion_input_dialog.dart';
import 'package:grocery_scanner/screens/home/profile/input_dialogs/profile_display_name_input_dialog.dart';
import 'package:grocery_scanner/screens/home/profile/input_dialogs/profile_preferences_input_dialog.dart';
import 'package:grocery_scanner/screens/home/profile/input_dialogs/profile_restrictions_input_dialog.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_button.dart';
import 'package:grocery_scanner/screens/home/profile/shared/preferences_list.dart';
import 'package:grocery_scanner/screens/home/profile/shared/restrictions_list.dart';
import 'package:grocery_scanner/services/auth_service.dart';
import 'package:grocery_scanner/services/user_database_service.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/error_page.dart';
import 'package:grocery_scanner/shared/label_row.dart';
import 'package:grocery_scanner/shared/loading.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();

  String? tempDisplayName;
  List preferences = [];
  List restrictions = [];

  @override
  void initState() {
    super.initState();
    _fetchPreferencesAndRestrictions();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context)!;

    return FutureBuilder(
      future: UserDatabaseService(user.uid).userCollection.doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorPage();
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const ErrorPage();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        UserData loggedUser = UserData.fromJson(data);

        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    // Logged User Info
                    Row(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          color: green,
                          size: 60,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tempDisplayName ?? loggedUser.displayName,
                              style: const TextStyle(
                                  color: black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              loggedUser.emailAddress,
                              style: const TextStyle(
                                  color: black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),

                    // Restrictions
                    const SizedBox(height: 25),
                    LabelRow(
                      icon: Icons.no_meals,
                      labelText: "Ograniczenia i uczulenia",
                      color: green,
                      isSecondaryIconEnabled: true,
                      secondaryIcon: Icons.edit,
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => ProfileRestrictionsInputDialog(
                          initValue: restrictions,
                          setValue: (input) async {
                            setState(() => restrictions = input);

                            bool result =
                                await UserDatabaseService(_auth.currentUserUid!)
                                    .updateField("restrictions", input);
                            if (result) {
                              Fluttertoast.showToast(
                                msg:
                                    "Zaktualizowano listę ograniczeń i uczeleń",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "Nie udało się zaktualizować listy ograniczeń i uczeleń",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    RestrictionsList(restrictions: restrictions),

                    // Preferences
                    const SizedBox(height: 15),
                    LabelRow(
                      icon: Icons.kebab_dining,
                      labelText: "Twoje preferencje",
                      color: green,
                      isSecondaryIconEnabled: true,
                      secondaryIcon: Icons.edit,
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => ProfilePreferencesInputDialog(
                          initValue: preferences,
                          setValue: (input) async {
                            setState(() => preferences = input);

                            bool result =
                                await UserDatabaseService(_auth.currentUserUid!)
                                    .updateField("preferences", input);
                            if (result) {
                              Fluttertoast.showToast(
                                msg: "Zaktualizowano listę preferencji",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "Nie udało się zaktualizować listy preferencji",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 16,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    PreferencesList(list: preferences),

                    // Profile Info
                    const SizedBox(height: 15),
                    const LabelRow(
                      icon: Icons.info,
                      labelText: "Informacje o profilu",
                      color: green,
                      isSecondaryIconEnabled: false,
                    ),
                    _renderProfileInfo(
                      displayName: tempDisplayName ?? loggedUser.displayName,
                      emailAddress: loggedUser.emailAddress,
                      createdAtTimestamp: loggedUser.createdAtTimestamp,
                    ),

                    // Options (delete account + sign out)
                    const SizedBox(height: 15),
                    const LabelRow(
                      icon: Icons.settings,
                      labelText: "Opcje",
                      color: green,
                      isSecondaryIconEnabled: false,
                    ),
                    const SizedBox(height: 10),

                    HorizontalButton(
                      icon: Icons.add,
                      label: "Dodaj nowy produkt",
                      color: green,
                      onPressed: () =>
                          Navigator.of(context).pushNamed("/product/add"),
                    ),

                    HorizontalButton(
                      icon: Icons.logout,
                      label: "Wyloguj się",
                      color: green,
                      onPressed: () async => await _auth.signOut(),
                    ),

                    HorizontalButton(
                      icon: Icons.person_off,
                      label: "Usuń konto",
                      color: red,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ProfileDeletionInputDialog(
                          email: loggedUser.emailAddress,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future _fetchPreferencesAndRestrictions() async {
    List _preferences = await UserDatabaseService(_auth.currentUserUid!)
        .getFieldByName("preferences");
    List _restrictions = await UserDatabaseService(_auth.currentUserUid!)
        .getFieldByName("restrictions");

    setState(() {
      preferences = _preferences;
      restrictions = _restrictions;
    });
  }

  Widget _renderProfileInfo({
    required String displayName,
    required String emailAddress,
    required int createdAtTimestamp,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp * 1000);
    final accountCreatedDateFormatted =
        "${date.day.toString().padLeft(2, "0")}.${date.month.toString().padLeft(2, "0")}.${date.year}";
    final elapsedTimeFromAccountCreationFormatted =
        _formatElapsedTimeFromAccountCreation(createdAtTimestamp);

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Row(
            children: [
              const Text("Imię: ", style: TextStyle(fontSize: 16)),
              Text(
                displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => ProfileDisplayNameInputDialog(
                    initValue: displayName,
                    setValue: (input) async {
                      setState(() => tempDisplayName = input);
                      bool result =
                          await UserDatabaseService(_auth.currentUserUid!)
                              .updateField("display_name", input);
                      if (result) {
                        Fluttertoast.showToast(
                          msg: "Zmieniono imię",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 16,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Nie udało się zmienić imienia",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 16,
                        );
                      }
                    },
                  ),
                ),
                child: const Icon(Icons.edit, color: green),
              )
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text("Adres e-mail: ", style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  emailAddress,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text("Utworzono: ", style: TextStyle(fontSize: 16)),
              Text(
                "$accountCreatedDateFormatted ($elapsedTimeFromAccountCreationFormatted)",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _formatElapsedTimeFromAccountCreation(int createdAtTimestamp) {
    num difference =
        (DateTime.now().millisecondsSinceEpoch / 1000) - createdAtTimestamp;
    int days = (difference / (60 * 60 * 24)).floor();
    return days == 1 ? "$days dzień temu" : "$days dni temu";
  }
}
