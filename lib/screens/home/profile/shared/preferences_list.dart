import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class PreferencesList extends StatelessWidget {
  final List<dynamic> list;
  const PreferencesList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5.0),
        Wrap(children: [
          if (list.isEmpty)
            Container(
              margin: const EdgeInsets.all(5.0),
              child: const Column(children: [
                Text(
                  "Póki co nic tu nie ma...",
                  style: TextStyle(fontSize: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Kliknij "),
                    Icon(Icons.edit, color: green),
                    Text(" po prawej stronie, aby dodać element")
                  ],
                )
              ]),
            )
          else
            for (String e in list)
              Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: green),
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 16.0),
                ),
              )
        ])
      ],
    );
  }
}
