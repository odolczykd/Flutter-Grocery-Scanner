import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_button.dart';
import 'package:grocery_scanner/shared/colors.dart';

class ProductNotFound extends StatelessWidget {
  const ProductNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.no_food,
                  size: 80,
                  color: orange,
                ),
                const SizedBox(height: 15),
                const Text("Nie znaleziono produktu",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                const Text(
                  "Upewnij się, czy poprawnie odczytano kod kreskowy skanowanego produktu",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Jeśli produkt nie istnieje w naszej bazie, możesz go dodać w łatwy i wygodny sposób!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),
                HorizontalButton(
                    icon: Icons.add_circle_outline,
                    label: "Dodaj nowy produkt",
                    color: orange,
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/product/add")),
                const SizedBox(height: 10),
                HorizontalButton(
                    icon: Icons.home,
                    label: "Wróć na stronę główną",
                    color: orange,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/home");
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
