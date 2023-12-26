import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product.dart';
import 'package:grocery_scanner/screens/home/main_page/add_new_product_tile.dart';
import 'package:grocery_scanner/screens/home/main_page/product_tile.dart';
import 'package:grocery_scanner/services/auth.dart';
import 'package:grocery_scanner/services/product_database.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:provider/provider.dart';
import 'package:grocery_scanner/models/user.dart';
import 'package:grocery_scanner/services/user_database.dart';
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
          return const Text("Cos poszlo nie tak");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Dokument nie istnieje");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        UserData loggedUser = UserData.fromJson(data);

        return Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.waving_hand,
                      color: green,
                      size: 45,
                    ),
                    const SizedBox(width: 15),
                    Text("Cześć, ${loggedUser.username}!",
                        style: const TextStyle(
                            color: black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    Icon(Icons.update, color: green),
                    SizedBox(width: 5),
                    Text(
                      "Ostatnio skanowane produkty",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                if (recentlyScannedProducts.isEmpty)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Póki co nic tu nie ma...",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                            "Skanuj produkty, a będą się one wyświetlać w tej sekcji"),
                      ],
                    ),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: recentlyScannedProducts
                          .map((product) => ProductTile(product))
                          .toList(),
                    ),
                  ),
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
                if (pinnedProducts.isEmpty)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Póki co nic tu nie ma...",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                            "Przypinaj produkty, a będą się one wyświetlać w tej sekcji"),
                      ],
                    ),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: pinnedProducts
                          .map((product) => ProductTile(product))
                          .toList(),
                    ),
                  ),
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
                if (yourProducts.isEmpty)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Póki co nic tu nie ma...",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                            "Dodawaj produkty, a będą się one wyświetlać w tej sekcji"),
                      ],
                    ),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: yourProducts
                          .map((product) => ProductTile(product))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Icon(Icons.touch_app, color: green),
                    SizedBox(width: 5.0),
                    Text(
                      "Przyciski akcji",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const AddNewProductTile()
              ],
            ),
          )),
        );
      },
    );
  }

  void _getAllProductsData() async {
    // Get Products' barcodes
    List pinnedProductsBarcodes = await getProductsFromUser("pinnedProducts");
    List recentlyScannedProductsBarcodes =
        await getProductsFromUser("recentlyScannedProducts");
    List yourProductsBarcodes = await getProductsFromUser("yourProducts");

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
