import 'package:flutter/material.dart';
import 'package:grocery_scanner/services/auth.dart';
import 'package:grocery_scanner/shared/colors.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();

    return GestureDetector(
      onTap: () => auth.signOut(),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: green),
          child: const Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: white,
                  size: 40,
                ),
                SizedBox(height: 10),
                Text(
                  "Wyloguj się",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
