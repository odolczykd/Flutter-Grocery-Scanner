import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class ProductAllergensDialogContent extends StatelessWidget {
  const ProductAllergensDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            "Alergeny pokarmowe i składniki wywołujące reakcje nietolerancji muszą być oznaczane w wykazie składników oferowanych środków spożywczych z dokładnym odniesieniem do ich nazwy.",
          ),
          const SizedBox(height: 5),
          const Text(
            "Nazwa alergenu, substancji wywołującej reakcję nietolerancji oraz środków spożywczych zawierających składniki złożone musi być podkreślona w wykazie składników środka spożywczego za pomocą pisma wyraźnie odróżniającego ją od reszty wykazu składników, np. za pomocą innej czcionki, stylu pisma lub koloru tła, np.:",
          ),
          const SizedBox(height: 5),
          RichText(
            text: const TextSpan(
              text: "Składniki: pomidory, cukier, przecier z ",
              style: TextStyle(color: black, fontStyle: FontStyle.italic),
              children: [
                TextSpan(
                  text: "selera",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ", skrobia modyfikowana, sól, zioła.",
                  style: TextStyle(
                    color: black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          RichText(
            text: const TextSpan(
              text:
                  "Składniki: Sok z czarnej porzeczki, wino musujące (zawiera ",
              style: TextStyle(
                color: black,
                fontStyle: FontStyle.italic,
              ),
              children: [
                TextSpan(
                    text: "siarczyny",
                    style: TextStyle(
                      color: black,
                      decoration: TextDecoration.underline,
                    )),
                TextSpan(
                  text: ")",
                  style: TextStyle(
                    color: black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          RichText(
            text: const TextSpan(
              text: "Składniki: lecytyna ",
              style: TextStyle(color: black, fontStyle: FontStyle.italic),
              children: [
                TextSpan(
                  text: "z soi",
                  style: TextStyle(
                    color: black,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ", dekstryna "),
                TextSpan(
                  text: "z pszenicy",
                  style: TextStyle(
                    color: black,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ", amorat (może zawierać "),
                TextSpan(
                  text: "midgały",
                  style: TextStyle(
                    color: black,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ")")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
