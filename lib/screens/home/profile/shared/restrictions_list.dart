import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/product_creator/allergens_list.dart';
import 'package:grocery_scanner/shared/colors.dart';

class RestrictionsList extends StatelessWidget {
  final List restrictions;
  final bool isOfflineMode;
  const RestrictionsList({
    super.key,
    required this.restrictions,
    this.isOfflineMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (restrictions.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 15),
        child: Column(
          children: [
            if (isOfflineMode)
              const Text("Nie wskazano żadnych alergenów")
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
      );
    }
    return Column(
      children: restrictions
          .map(
            (restr) => Row(
              children: [
                const SizedBox(width: 5),
                const Icon(Icons.navigate_next, color: green),
                Expanded(
                  child: Text(
                    allergenLabels[restr]!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
