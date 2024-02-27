import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class PreferencesList extends StatelessWidget {
  final List<dynamic> list;
  final bool isOfflineMode;
  const PreferencesList({
    super.key,
    required this.list,
    this.isOfflineMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Center(
          child: Column(
            children: [
              if (isOfflineMode)
                const Text("Nie wskazano żadnych preferencji żywieniowych")
              else
                const Text(
                  "Póki co nic tu nie ma...",
                  style: TextStyle(fontSize: 16),
                ),
              if (!isOfflineMode)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Kliknij "),
                    Icon(Icons.edit, color: green),
                    Text(" po prawej stronie, aby dodać element")
                  ],
                )
            ],
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          children: list
              .map(
                (pref) => Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: green),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    _mapPreferencesCode(pref),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }
  }

  String _mapPreferencesCode(String preferenceKey) {
    Map<String, String> translations = {
      "vegetarian": "wegetariańskie",
      "vegan": "wegańskie",
      "palm_oil_free": "bez oleju palmowego"
    };

    return translations[preferenceKey]!;
  }
}
