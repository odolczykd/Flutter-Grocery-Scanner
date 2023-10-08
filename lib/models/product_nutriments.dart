import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class ProductNutriments {
  var energyKJ = (name: "", value: "", value_100: "");
  var energyKcal = (name: "", value: "", value_100: "");
  var fat = (name: "", value: "", value_100: "");
  var saturatedFat = (name: "", value: "", value_100: "");
  var carbohydrates = (name: "", value: "", value_100: "");
  var sugars = (name: "", value: "", value_100: "");
  var proteins = (name: "", value: "", value_100: "");
  var salt = (name: "", value: "", value_100: "");

  ProductNutriments(
      {required this.energyKJ,
      required this.energyKcal,
      required this.fat,
      required this.saturatedFat,
      required this.carbohydrates,
      required this.sugars,
      required this.proteins,
      required this.salt});

  factory ProductNutriments.fromJson(Map<String, dynamic> json) {
    return ProductNutriments(energyKJ: (
      name: "energia [kJ]",
      value: (json["energy"] as num).toPrecision(3),
      value_100: (json["energy_100g"] as num).toPrecision(3),
    ), energyKcal: (
      name: "energia [kcal]",
      value: (json["energy-kcal"] as num).toPrecision(3),
      value_100: (json["energy-kcal_100g"] as num).toPrecision(3),
    ), fat: (
      name: "tłuszcz",
      value: (json["fat"] as num).toPrecision(3),
      value_100: (json["fat_100g"] as num).toPrecision(3),
    ), saturatedFat: (
      name: "kwasy nasycone",
      value: (json["saturated-fat"] as num).toPrecision(3),
      value_100: (json["saturated-fat_100g"] as num).toPrecision(3),
    ), carbohydrates: (
      name: "węglowodany",
      value: (json["carbohydrates"] as num).toPrecision(3),
      value_100: (json["carbohydrates_100g"] as num).toPrecision(3),
    ), sugars: (
      name: "cukry",
      value: (json["sugars"] as num).toPrecision(3),
      value_100: (json["sugars_100g"] as num).toPrecision(3),
    ), proteins: (
      name: "białko",
      value: (json["proteins"] as num).toPrecision(3),
      value_100: (json["proteins_100g"] as num).toPrecision(3),
    ), salt: (
      name: "sól",
      // value: "N/A",
      // value_100: "N/A",
      value: _isPresent(json["salt"])
          ? (json["salt"] as num).toPrecision(3)
          : "N/A",
      value_100: _isPresent(json["salt_100g"])
          ? (json["salt_100g"] as num).toPrecision(3)
          : "N/A"
    ));
  }

  Widget renderTable() {
    var nutriments = [
      energyKJ,
      energyKcal,
      fat,
      saturatedFat,
      carbohydrates,
      sugars,
      proteins,
      salt
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tabela może zawierać wartości przybliżone.",
            style: TextStyle(fontStyle: FontStyle.italic)),
        const SizedBox(height: 5.0),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1)
          },
          border:
              TableBorder.symmetric(inside: const BorderSide(color: greyBg)),
          children: [
            TableRow(children: [
              Container(
                color: green,
                padding: const EdgeInsets.all(5.0),
                child: const Text("wartość odżywcza",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: white)),
              ),
              Container(
                color: green,
                padding: const EdgeInsets.all(5.0),
                child: const Text("w porcji",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: white)),
              ),
              Container(
                color: green,
                padding: const EdgeInsets.all(5.0),
                child: const Text("w 100 g/ml",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: white)),
              )
            ])
          ],
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1)
          },
          border:
              TableBorder.symmetric(inside: const BorderSide(color: greyBg)),
          children: nutriments
              .map((nutr) => TableRow(children: [
                    Container(
                      color: nutriments.indexOf(nutr) % 2 == 0
                          ? greyBg
                          : greyButton,
                      padding: const EdgeInsets.all(5.0),
                      child: Text(nutr.name),
                    ),
                    Container(
                      color: nutriments.indexOf(nutr) % 2 == 0
                          ? greyBg
                          : greyButton,
                      padding: const EdgeInsets.all(5.0),
                      child: Text(nutr.value),
                    ),
                    Container(
                      color: nutriments.indexOf(nutr) % 2 == 0
                          ? greyBg
                          : greyButton,
                      padding: const EdgeInsets.all(5.0),
                      child: Text(nutr.value_100),
                    )
                  ]))
              .toList(),
        ),
      ],
    );
  }
}

extension Precision on num {
  String toPrecision(int n) {
    num mod = pow(10, n);
    return ((this * mod).round() / mod).toString();
  }
}

bool _isPresent(var value) => !(value == null && value == "");
