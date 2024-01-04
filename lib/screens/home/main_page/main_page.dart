import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/screens/home/main_page/product_tile.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_button.dart';
import 'package:grocery_scanner/services/auth_service.dart';
import 'package:grocery_scanner/services/product_database_service.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/error_page.dart';
import 'package:provider/provider.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/services/user_database_service.dart';
import 'package:grocery_scanner/shared/loading.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AuthService _auth = AuthService();

  List<Product> pinnedProducts = [];
  List<Product> recentlyScannedProducts = [];
  List<Product> yourProducts = [];

  @override
  void initState() {
    super.initState();
    _getAllProductsData();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context)!;
    CollectionReference users = UserDatabaseService(user.uid).userCollection;

    return FutureBuilder(
      future: users.doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorPage();
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const ErrorPage();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        Map<String, dynamic> userSnapshotData =
            snapshot.data!.data() as Map<String, dynamic>;
        UserData loggedUser = UserData.fromJson(userSnapshotData);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greetings
                Row(
                  children: [
                    const Icon(
                      Icons.waving_hand,
                      color: green,
                      size: 45,
                    ),
                    const SizedBox(width: 15),
                    Text("Cześć, ${loggedUser.displayName}!",
                        style: const TextStyle(
                            color: black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ],
                ),

                // Recently Scanned Products
                const SizedBox(height: 30),
                const Row(
                  children: [
                    Icon(Icons.update, color: green),
                    SizedBox(width: 5),
                    Text(
                      "Ostatnio przeglądane produkty",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                _renderRecentlyScannedProducts(),

                // Pinned Products
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Icon(Icons.push_pin, color: green),
                    SizedBox(width: 5),
                    Text(
                      "Przypięte produkty",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                _renderPinnedProducts(),

                // Your Products
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Icon(Icons.person_add_alt_1, color: green),
                    SizedBox(width: 5),
                    Text(
                      "Produkty dodane przez Ciebie",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                _renderYourProducts(),

                // Action Buttons
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Icon(Icons.touch_app, color: green),
                    SizedBox(width: 5),
                    Text(
                      "Przyciski akcji",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    HorizontalButton(
                        icon: Icons.add,
                        label: "Dodaj nowy produkt",
                        color: green,
                        onPressed: () =>
                            Navigator.of(context).pushNamed("/product/add")),
                    HorizontalButton(
                        icon: Icons.logout,
                        label: "Wyloguj się",
                        color: green,
                        onPressed: () async => await _auth.signOut())
                  ],
                ),
                const SizedBox(height: 20),
              ],
            )),
          ),
        );
      },
    );
  }

  Widget _renderRecentlyScannedProducts() {
    if (recentlyScannedProducts.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Póki co nic tu nie ma...",
              style: TextStyle(fontSize: 16),
            ),
            Text("Skanuj produkty, a będą się one wyświetlać w tej sekcji"),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: recentlyScannedProducts.reversed
              .map((product) => ProductTile(product))
              .toList(),
        ),
      );
    }
  }

  Widget _renderPinnedProducts() {
    if (pinnedProducts.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Póki co nic tu nie ma...",
              style: TextStyle(fontSize: 16),
            ),
            Text("Przypinaj produkty, a będą się one wyświetlać w tej sekcji"),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              pinnedProducts.map((product) => ProductTile(product)).toList(),
        ),
      );
    }
  }

  Widget _renderYourProducts() {
    if (yourProducts.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Póki co nic tu nie ma...",
              style: TextStyle(fontSize: 16),
            ),
            Text("Dodawaj produkty, a będą się one wyświetlać w tej sekcji"),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              yourProducts.map((product) => ProductTile(product)).toList(),
        ),
      );
    }
  }

  // TODO: Check if Future causes errors
  Future _getAllProductsData() async {
    // Get Products' barcodes
    List pinnedProductsBarcodes = await getProductsFromUser("pinned_products");
    List recentlyScannedProductsBarcodes =
        await getProductsFromUser("recently_scanned_products");
    List yourProductsBarcodes = await getProductsFromUser("your_products");

    // Get Product models from given barcodes
    List<Product> _pinnedProducts =
        await getProductModelsByBarcodes(pinnedProductsBarcodes);
    List<Product> _recentlyScannedProducts =
        await getProductModelsByBarcodes(recentlyScannedProductsBarcodes);
    List<Product> _yourProducts =
        await getProductModelsByBarcodes(yourProductsBarcodes);

    setState(() {
      pinnedProducts = _pinnedProducts;
      recentlyScannedProducts = _recentlyScannedProducts.reversed.toList();
      yourProducts = _yourProducts.reversed.toList();
    });
  }

  Future<List> getProductsFromUser(String fieldName) async {
    List products = await UserDatabaseService(_auth.currentUserUid!)
        .getFieldByName(fieldName);
    return products;
  }

  Future<List<Product>> getProductModelsByBarcodes(List barcodesList) async {
    List<Product> products = [];
    List<String> barcodes = barcodesList.map((e) => e as String).toList();

    for (String barcode in barcodes) {
      var product = await ProductDatabaseService(barcode).getProduct();
      if (product != null) {
        products.add(product);
      }
    }

    return products;
  }
}
