import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    return Column(
      children: [Text(userData.username)],
    );
  }
}
