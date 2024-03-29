import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/screens/home/profile/shared/preferences_list.dart';
import 'package:grocery_scanner/screens/home/profile/shared/restrictions_list.dart';
import 'package:grocery_scanner/screens/offline_mode/description_banner.dart';
import 'package:grocery_scanner/screens/offline_mode/product_tiles_grid.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/hive_boxes.dart';
import 'package:grocery_scanner/shared/label_row.dart';

class OfflineModePage extends StatefulWidget {
  const OfflineModePage({super.key});

  @override
  State<OfflineModePage> createState() => _OfflineModePageState();
}

class _OfflineModePageState extends State<OfflineModePage> {
  late UserData? loggedUser;
  late List<ProductOffline> products;

  @override
  void initState() {
    super.initState();
    loggedUser = userLocalStorage.getAt(0);
    products = productLocalStorage.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyBg,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      color: green,
                      size: 45,
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Tryb offline",
                      style: TextStyle(
                          color: black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed("/");
                      },
                      child: const Icon(
                        Icons.refresh,
                        color: green,
                        size: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Mimo braku dostępu do Internetu, możesz przeglądać produkty zapisane w pamięci podręcznej urządzenia!",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Jak to działa?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const DescriptionBanner(
                  text:
                      "Gdy aplikacja ma dostęp do Internetu, każdy obejrzany przez Ciebie produkt zostaje zapisany w pamięci urządzenia!",
                  icon: Icons.touch_app,
                  color: green,
                ),
                const DescriptionBanner(
                  text:
                      "Bycie zalogowanym pozwala na informowanie, czy zapisany produkt jest dla Ciebie odpowiedni!",
                  icon: Icons.no_meals,
                  color: green,
                ),
                const DescriptionBanner(
                  text:
                      "Dzięki trybowi offline możesz szybko i wygodnie wyświetlić szczegóły produktu bez konieczności dostępu do Internetu!",
                  icon: Icons.system_update,
                  color: green,
                ),

                // Restrictions
                if (loggedUser != null) const SizedBox(height: 20),
                if (loggedUser != null)
                  const LabelRow(
                    icon: Icons.no_meals,
                    labelText: "Ograniczenia i uczulenia",
                    color: green,
                    isSecondaryIconEnabled: false,
                  ),
                if (loggedUser != null)
                  RestrictionsList(restrictions: loggedUser!.restrictions),

                // Preferences
                if (loggedUser != null) const SizedBox(height: 20),
                if (loggedUser != null)
                  const LabelRow(
                    icon: Icons.kebab_dining,
                    labelText: "Twoje preferencje",
                    color: green,
                    isSecondaryIconEnabled: false,
                  ),
                if (loggedUser != null)
                  PreferencesList(
                    list: loggedUser!.preferences,
                    isOfflineMode: true,
                  ),

                const SizedBox(height: 20),
                const LabelRow(
                  icon: Icons.download,
                  labelText: "Zapisane produkty",
                  color: green,
                  isSecondaryIconEnabled: false,
                ),
                ProductTilesGrid(user: loggedUser, products: products)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
