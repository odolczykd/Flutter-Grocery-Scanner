import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';

class ProductNutriments {
  Map<String, dynamic> energyKJ;
  Map<String, dynamic> energyKcal;
  Map<String, dynamic> fat;
  Map<String, dynamic> saturatedFat;
  Map<String, dynamic> carbohydrates;
  Map<String, dynamic> sugars;
  Map<String, dynamic> proteins;
  Map<String, dynamic> salt;

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
    var energyKJFromJson = {
      "value": json["energy"] != null
          ? (json["energy"] as num).toPrecision(3).toString()
          : "N/A",
      "value_100g": json["energy_100g"] != null
          ? (json["energy_100g"] as num).toPrecision(3).toString()
          : "N/A",
    };
    var energyKcalFromJson = {
      "value": json["energy-kcal"] != null
          ? (json["energy-kcal"] as num).toPrecision(3).toString()
          : "N/A",
      "value_100g": json["energy-kcal_100g"] != null
          ? (json["energy-kcal_100g"] as num).toPrecision(3).toString()
          : "N/A",
    };
    var fatFromJson = {
      "value": json["fat"] != null
          ? (json["fat"] as num).toPrecision(3).toString()
          : "N/A",
      "value_100g": json["fat_100g"] != null
          ? (json["fat_100g"] as num).toPrecision(3).toString()
          : "N/A",
    };
    var saturatedFatFromJson = {
      "value": json["saturated-fat"] != null
          ? (json["saturated-fat"] as num).toPrecision(3).toString()
          : "N/A",
      "value_100g": json["saturated-fat_100g"] != null
          ? (json["saturated-fat_100g"] as num).toPrecision(3).toString()
          : "N/A",
    };
    var carbohydratesFromJson = {
      "value": json["carbohydrates"] != null
          ? (json["carbohydrates"] as num).toPrecision(3).toString()
          : "N/A",
      "value_100g": json["carbohydrates_100g"] != null
          ? (json["carbohydrates_100g"] as num).toPrecision(3).toString()
          : "N/A",
    };
    var sugarsFromJson = {
      "value": json["sugars"] != null
          ? (json["sugars"] as num).toPrecision(3).toString()
          : "N/A",
      "value_100g": json["sugars_100g"] != null
          ? (json["sugars_100g"] as num).toPrecision(3).toString()
          : "N/A",
    };
    var proteinsFromJson = {
      "value": json["proteins"] != null
          ? (json["proteins"] as num).toPrecision(3).toString()
          : "N/A",
      "value_100g": json["proteins_100g"] != null
          ? (json["proteins_100g"] as num).toPrecision(3).toString()
          : "N/A",
    };
    var saltFromJson = {
      "value": json["salt"] != null
          ? (json["salt"] as num).toPrecision(3).toString()
          : "N/A",
      "value_100g": json["salt_100g"] != null
          ? (json["salt_100g"] as num).toPrecision(3).toString()
          : "N/A",
    };

    return ProductNutriments(
        energyKJ: energyKJFromJson,
        energyKcal: energyKcalFromJson,
        fat: fatFromJson,
        saturatedFat: saturatedFatFromJson,
        carbohydrates: carbohydratesFromJson,
        sugars: sugarsFromJson,
        proteins: proteinsFromJson,
        salt: saltFromJson);
  }

  Widget renderTable() {
    var nutriments = [
      if (_areBothPresent(energyKJ)) ("energia [KJ]", energyKJ),
      if (_areBothPresent(energyKcal)) ("energia [kcal]", energyKcal),
      if (_areBothPresent(fat)) ("tłuszcz", fat),
      if (_areBothPresent(saturatedFat)) ("kwasy nasycone", saturatedFat),
      if (_areBothPresent(carbohydrates)) ("węglowodany", carbohydrates),
      if (_areBothPresent(sugars)) ("cukry", sugars),
      if (_areBothPresent(proteins)) ("białko", proteins),
      if ((_areBothPresent(salt))) ("sól", salt)
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tabela może zawierać wartości przybliżone.",
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
        const SizedBox(height: 5),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2)
          },
          border:
              TableBorder.symmetric(inside: const BorderSide(color: greyBg)),
          children: [
            TableRow(children: [
              Container(
                color: green,
                padding: const EdgeInsets.all(5),
                child: const Text("wartość odżywcza",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: white)),
              ),
              Container(
                color: green,
                padding: const EdgeInsets.all(5),
                child: const Text("w porcji",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: white)),
              ),
              Container(
                color: green,
                padding: const EdgeInsets.all(5),
                child: const Text("w 100 g/ml",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: white)),
              )
            ])
          ],
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2)
          },
          border:
              TableBorder.symmetric(inside: const BorderSide(color: greyBg)),
          children: nutriments
              .map((nutr) => TableRow(children: [
                    Container(
                      color: nutriments.indexOf(nutr) % 2 == 0
                          ? greyBg
                          : greyButton,
                      padding: const EdgeInsets.all(5),
                      child:
                          Text(nutr.$1, style: const TextStyle(fontSize: 15)),
                    ),
                    Container(
                      color: nutriments.indexOf(nutr) % 2 == 0
                          ? greyBg
                          : greyButton,
                      padding: const EdgeInsets.all(5),
                      child: Text(nutr.$2["value"],
                          style: const TextStyle(fontSize: 15)),
                    ),
                    Container(
                      color: nutriments.indexOf(nutr) % 2 == 0
                          ? greyBg
                          : greyButton,
                      padding: const EdgeInsets.all(5),
                      child: Text(nutr.$2["value_100g"],
                          style: const TextStyle(fontSize: 15)),
                    )
                  ]))
              .toList(),
        ),
      ],
    );
  }
}

bool _areBothPresent(Map<String, dynamic> nutriment) =>
    nutriment["value"] != "N/A" || nutriment["value_100g"] != "N/A";

extension Precision on num {
  String toPrecision(int n) {
    num mod = pow(10, n);
    return ((this * mod).round() / mod).toString();
  }
}
