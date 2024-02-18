import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

const preferencesKeys = ["vegetarian", "vegan", "palm_oil_free"];
const preferencesNames = ["wegetariańskie", "wegańskie", "bez oleju palmowego"];

class ProfilePreferencesInputDialog extends StatefulWidget {
  final List initValue;
  final Function(List) setValue;

  const ProfilePreferencesInputDialog(
      {super.key, required this.initValue, required this.setValue});

  @override
  State<ProfilePreferencesInputDialog> createState() =>
      _ProfilePreferencesInputDialogState();
}

class _ProfilePreferencesInputDialogState
    extends State<ProfilePreferencesInputDialog> {
  List checkedPreferences = [];

  @override
  void initState() {
    super.initState();
    checkedPreferences = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Edytuj preferencje żywieniowe",
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
              children: preferencesKeys
                  .asMap()
                  .entries
                  .map(
                    (entry) => CheckboxListTile(
                      title: Text(preferencesNames[entry.key]),
                      value: checkedPreferences.contains(entry.value),
                      activeColor: green,
                      onChanged: (value) {
                        if (value!) {
                          setState(
                            () => checkedPreferences
                                .add(preferencesKeys[entry.key]),
                          );
                        } else {
                          setState(
                            () => checkedPreferences
                                .remove(preferencesKeys[entry.key]),
                          );
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
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
            widget.setValue(checkedPreferences);
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: black),
          child: const Text("OK"),
        )
      ],
    );
  }
}
