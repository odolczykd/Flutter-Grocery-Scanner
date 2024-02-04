import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/auth_listener.dart';
import 'package:grocery_scanner/screens/offline_mode/offline_mode_page.dart';
import 'package:grocery_scanner/shared/error_page.dart';
import 'package:grocery_scanner/shared/loading.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionChecker extends StatelessWidget {
  const ConnectionChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: InternetConnectionCheckerPlus().hasConnection,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return const ErrorPage();
        }

        final connection = snapshot.data!;
        return connection ? const AuthListener() : const OfflineModePage();
      },
    );
  }
}
