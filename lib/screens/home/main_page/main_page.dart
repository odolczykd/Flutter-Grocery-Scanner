import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/screens/home/main_page/product_tile.dart';
import 'package:grocery_scanner/screens/home/profile/shared/horizontal_button.dart';
import 'package:grocery_scanner/services/auth_service.dart';
import 'package:grocery_scanner/services/product_database_service.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/error_page.dart';
import 'package:grocery_scanner/shared/hive_boxes.dart';
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

  List<String> pinnedProducts = [];
  List<String> recentlyScannedProducts = [];
  List<String> yourProducts = [];

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

        // Save User Locally
        saveUserLocally(loggedUser);

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
                      Text(
                        "Cześć, ${loggedUser.displayName}!",
                        style: const TextStyle(
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

                  // Recently Scanned Products
                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Icon(Icons.update, color: green),
                      SizedBox(width: 5),
                      Text(
                        "Ostatnio przeglądane produkty",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                            Navigator.of(context).pushNamed("/product/add"),
                      ),
                      HorizontalButton(
                        icon: Icons.logout,
                        label: "Wyloguj się",
                        color: green,
                        onPressed: () async => await _auth.signOut(),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _renderRecentlyScannedProducts() {
    return FutureBuilder(
      future: getProductModelsByBarcodes(recentlyScannedProducts),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        if (!snapshot.hasData) {
          return const Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Coś poszło nie tak...",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Nie udało się wczytać produktów",
                textAlign: TextAlign.center,
              ),
            ],
          );
        } else {
          final recentlyScannedProducts = snapshot.data!;

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
                  Text(
                    "Przeglądaj produkty, a będą się one wyświetlać w tej sekcji",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: recentlyScannedProducts
                    .map((product) => ProductTile(product))
                    .toList(),
              ),
            );
          }
        }
      },
    );
  }

  Widget _renderPinnedProducts() {
    return FutureBuilder(
      future: getProductModelsByBarcodes(pinnedProducts),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        if (!snapshot.hasData) {
          return const Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Coś poszło nie tak...",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Nie udało się wczytać produktów",
                textAlign: TextAlign.center,
              ),
            ],
          );
        } else {
          final pinnedProducts = snapshot.data!;

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
                  Text(
                    "Przypinaj produkty, a będą się one wyświetlać w tej sekcji",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: pinnedProducts
                    .map((product) => ProductTile(product))
                    .toList(),
              ),
            );
          }
        }
      },
    );
  }

  Widget _renderYourProducts() {
    return FutureBuilder(
      future: getProductModelsByBarcodes(yourProducts),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        if (!snapshot.hasData) {
          return const Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Coś poszło nie tak...",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Nie udało się wczytać produktów",
                textAlign: TextAlign.center,
              ),
            ],
          );
        } else {
          final yourProducts = snapshot.data!;

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
                  Text(
                    "Dodawaj produkty, a będą się one wyświetlać w tej sekcji",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: yourProducts
                    .map((product) => ProductTile(product))
                    .toList(),
              ),
            );
          }
        }
      },
    );
  }

  Future _getAllProductsData() async {
    // Get Products' barcodes
    List pinnedProductsBarcodes = await getProductsFromUser("pinned_products");
    List recentlyScannedProductsBarcodes =
        await getProductsFromUser("recently_scanned_products");
    List yourProductsBarcodes = await getProductsFromUser("your_products");

    setState(() {
      pinnedProducts = pinnedProductsBarcodes.map((e) => e as String).toList();
      recentlyScannedProducts =
          recentlyScannedProductsBarcodes.map((e) => e as String).toList();
      yourProducts = yourProductsBarcodes.map((e) => e as String).toList();
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
