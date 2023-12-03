// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';

import '../../../shared/colors.dart';
import '../../home/profile/shared/horizontal_button.dart';

class ProductCreatorAllergensList extends StatefulWidget {
  Set allergens;
  ProductCreatorAllergensList(this.allergens, {super.key});

  @override
  State<ProductCreatorAllergensList> createState() =>
      _ProductCreatorAllergensListState();
}

class _ProductCreatorAllergensListState
    extends State<ProductCreatorAllergensList> {
  Set<String> unusedAllergens = {};
  Set<String> allergensList = {};
  Widget? allergenSelect;
  Widget addNewAllergenButton = const Placeholder();

  @override
  void initState() {
    super.initState();
    unusedAllergens = _allergenLabels.keys
        .map((key) => key as String)
        .where((key) => !widget.allergens.contains(key))
        .toSet();
    allergensList = _createAllergensList();
    addNewAllergenButton = _createAddNewAllergenButton();
  }

  @override
  void didUpdateWidget(covariant ProductCreatorAllergensList oldWidget) {
    super.didUpdateWidget(oldWidget);
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
              addNewAllergenButton
            ]);
  }

  // Widget _createAllergenRow(String label) => Row(children: [
  //       const SizedBox(width: 5),
  //       const Icon(
  //         Icons.navigate_next,
  //         color: green,
  //       ),
  //       Text(_allergenLabels[label]!),
  //       const Spacer(),
  //       GestureDetector(
  //         onTap: () {},
  //         child: const Icon(
  //           Icons.delete,
  //           color: green,
  //         ),
  //       )
  //     ]) as Widget;

  // List<Widget> _createAllergensList() => widget.allergens
  //     .map(
  //       (e) => Row(children: [
  //         const SizedBox(width: 5),
  //         const Icon(
  //           Icons.navigate_next,
  //           color: green,
  //         ),
  //         Text(_allergenLabels[e]!)
  //       ]) as Widget,
  //     )
  //     .toList();

  Set<String> _createAllergensList() =>
      widget.allergens.map((e) => e as String).toSet();

  List<Widget> _createAllergensListWidget() => allergensList
      .map((e) => Row(children: [
            const SizedBox(width: 5),
            const Icon(
              Icons.navigate_next,
              color: green,
            ),
            Text(_allergenLabels[e]!),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  allergensList.remove(e);
                  unusedAllergens.add(e);
                });
              },
              child: const Icon(
                Icons.delete_outline,
                color: green,
              ),
            )
          ]) as Widget)
      .toList();

  Widget _createAllergenSelect() {
    List<DropdownMenuItem<String>> dropwdownItems = unusedAllergens
        .where((element) => !allergensList.contains(element))
        .map(
            (e) => DropdownMenuItem(value: e, child: Text(_allergenLabels[e]!)))
        .toList();

    return DropdownButton(
        style: const TextStyle(color: black, fontSize: 14),
        items: dropwdownItems,
        onChanged: (value) {
          setState(() {
            allergensList.add(value!);
            unusedAllergens.remove(value);
            allergenSelect = null;
          });
        });
  }

  Widget _createAddNewAllergenButton() => HorizontalButton(
      icon: Icons.add,
      label: "Dodaj alergen",
      color: green,
      onPressed: () {
        setState(() {
          allergenSelect = _createAllergenSelect();
        });
      });
}

Map<String, String> _allergenLabels = {
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
