import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_button.dart';
import 'package:grocery_scanner/shared/colors.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/svg/chicken-bite.svg",
                    width: 80, height: 80),
                const SizedBox(height: 15),
                const Text("Coś poszło nie tak...",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                const Text(
                  "Nie udało się poprawnie wczytać tej strony.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Upewnij się, że masz stabilne połączenie z Internetem lub spróbuj ponownie później.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),
                HorizontalButton(
                    icon: Icons.home,
                    label: "Wróć na stronę główną",
                    color: orange,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/");
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
