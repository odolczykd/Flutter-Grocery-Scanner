import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductNutriscoreDialogContent extends StatelessWidget {
  const ProductNutriscoreDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      const Text(
          "Nutri-Score jest systemem oznaczania wartości odżywczych. Znajdziesz go z przodu opakowania jako uzupełnienie informacji o wartościach odżywczych."),
      const SizedBox(height: 5),
      const Text(
          "Nutri-Score pozwala zidentyfikować wartości odżywcze produktu na pierwszy rzut oka. Wybierając żywność, możesz szybko i łatwo porównywać produkty tej samej kategorii. Ocenie poddawane są wartości odżywcze różnych składników danego produktu, a potem przedstawione na pięciostopniowej skali opatrzonej literą i odpowiadającym jej kolorem."),
      const SizedBox(height: 5),
      const Image(image: AssetImage("assets/img/nutriscore.png")),
      const SizedBox(height: 5),
      RichText(
          text: TextSpan(
              text: "Więcej na temat wskaźnika Nutri-Score",
              style: const TextStyle(color: green, fontSize: 16),
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrl(Uri.parse(
                    "https://www.gov.pl/web/psse-miedzyrzecz/czym-jest-i-co-oznacza-nutri-score")))),
    ]));
  }
}
