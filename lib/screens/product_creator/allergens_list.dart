// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/home/profile/shared/transparent_horizontal_button.dart';
import 'package:grocery_scanner/shared/colors.dart';

class ProductCreatorAllergensList extends StatefulWidget {
  final Set allergens;
  final Function(Set) callback;

  const ProductCreatorAllergensList(
      {required this.allergens, required this.callback, super.key});

  @override
  State<ProductCreatorAllergensList> createState() =>
      _ProductCreatorAllergensListState();
}

class _ProductCreatorAllergensListState
    extends State<ProductCreatorAllergensList> {
  Set<String> unusedAllergens = {};
  Set<String> allergensList = {};
  Widget? allergenSelect;
  Widget addNewAllergenButton = Container();

  @override
  void initState() {
    super.initState();
    unusedAllergens = allergenLabels.keys
        .map((key) => key as String)
        .where((key) => !widget.allergens.contains(key))
        .toSet();
    allergensList = _createAllergensList();
    addNewAllergenButton = _createAddNewAllergenButton();
  }

  @override
  void didUpdateWidget(covariant ProductCreatorAllergensList oldWidget) {
    super.didUpdateWidget(oldWidget);
    allergensList = _createAllergensList();
    if (widget.allergens != oldWidget.allergens) {
      allergensList = _createAllergensList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _createAllergensListWidget() +
          [
            if (allergenSelect != null) allergenSelect!,
            addNewAllergenButton,
          ],
    );
  }

  Set<String> _createAllergensList() =>
      widget.allergens.map((e) => e as String).toSet();

  List<Widget> _createAllergensListWidget() => allergensList
      .map(
        (e) => Row(
          children: [
            const SizedBox(width: 5),
            const Icon(
              Icons.navigate_next,
              color: green,
            ),
            Expanded(
              child: Text(
                allergenLabels[e]!,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                setState(
                  () {
                    allergensList.remove(e);
                    unusedAllergens.add(e);
                    widget.callback(allergensList);
                  },
                );
              },
              child: const Icon(
                Icons.delete,
                color: green,
              ),
            )
          ],
        ) as Widget,
      )
      .toList();

  Widget _createAllergenSelect() {
    List<DropdownMenuItem<String>> dropwdownItems = unusedAllergens
        .where((element) => !allergensList.contains(element))
        .map((e) => DropdownMenuItem(value: e, child: Text(allergenLabels[e]!)))
        .toList();

    return DropdownButton(
      hint: const Text("Wybierz alergen z listy..."),
      style: const TextStyle(color: black, fontSize: 14),
      items: dropwdownItems,
      onChanged: (value) {
        setState(
          () {
            allergensList.add(value!);
            unusedAllergens.remove(value);
            allergenSelect = null;
            widget.callback(allergensList);
          },
        );
      },
    );
  }

  Widget _createAddNewAllergenButton() => TransparentHorizontalButton(
        icon: Icons.add,
        iconSize: 24,
        label: "Dodaj alergen",
        color: green,
        onPressed: () {
          setState(() => allergenSelect = _createAllergenSelect());
        },
      );
}

Map<String, String> allergenLabels = {
  "gluten": "zboża zawierające gluten i produkty pochodne",
  "shellfish": "skorupiaki i produkty pochodne",
  "eggs": "jaja i produkty pochodne",
  "fish": "ryby i produkty pochodne",
  "peanuts": "orzeszki ziemne (arachidowe) i produkty pochodne",
  "soya": "soja i produkty pochodne",
  "milk": "mleko i produkty pochodne, laktoza",
  "nuts": "orzechy i produkty pochodne",
  "celery": "seler i produkty pochodne",
  "mustard": "gorczyca i produkty pochodne",
  "sesame_seeds": "nasiona sezamu i produkty pochodne",
  "sulphur_dioxide": "dwutlenek siarki, siarczyny i produkty pochodne",
  "lupin": "łubin i produkty pochodne",
  "molluscs": "mięczaki i produkty pochodne"
};
