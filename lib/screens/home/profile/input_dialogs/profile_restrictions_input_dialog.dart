import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

const allergenKeys = [
  "gluten",
  "shellfish",
  "eggs",
  "fish",
  "peanuts",
  "soya",
  "milk",
  "nuts",
  "celery",
  "mustard",
  "sesame_seeds",
  "sulphur_dioxide",
  "lupin",
  "molluscs"
];

const allergenNames = [
  "zboża zawierające gluten i produkty pochodne",
  "skorupiaki i produkty pochodne",
  "jaja i produkty pochodne",
  "ryby i produkty pochodne",
  "orzeszki ziemne (arachidowe) i produkty pochodne",
  "soja i produkty pochodne",
  "mleko i produkty pochodne, laktoza",
  "orzechy i produkty pochodne",
  "seler i produkty pochodne",
  "gorczyca i produkty pochodne",
  "nasiona sezamu i produkty pochodne",
  "dwutlenek siarki, siarczyny i produkty pochodne",
  "łubin i produkty pochodne",
  "mięczaki i produkty pochodne"
];

class ProfileRestrictionsInputDialog extends StatefulWidget {
  final List initValue;
  final Function(List) setValue;

  const ProfileRestrictionsInputDialog(
      {super.key, required this.initValue, required this.setValue});

  @override
  State<ProfileRestrictionsInputDialog> createState() =>
      _ProfileRestrictionsInputDialogState();
}

class _ProfileRestrictionsInputDialogState
    extends State<ProfileRestrictionsInputDialog> {
  List checkedAllergens = [];
  String validatorMsg = "";

  @override
  void initState() {
    super.initState();
    checkedAllergens = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Edytuj ograniczenia i uczulenia",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                children: allergenKeys
                    .asMap()
                    .entries
                    .map(
                      (entry) => CheckboxListTile(
                        title: Text(allergenNames[entry.key]),
                        value: checkedAllergens.contains(entry.value),
                        activeColor: green,
                        onChanged: (value) {
                          if (value!) {
                            setState(() =>
                                checkedAllergens.add(allergenKeys[entry.key]));
                          } else {
                            setState(() => checkedAllergens
                                .remove(allergenKeys[entry.key]));
                          }
                        },
                      ),
                    )
                    .toList()),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: black),
          child: const Text("ANULUJ"),
        ),
        TextButton(
          onPressed: () {
            widget.setValue(checkedAllergens);
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: black),
          child: const Text("OK"),
        )
      ],
    );
  }
}
