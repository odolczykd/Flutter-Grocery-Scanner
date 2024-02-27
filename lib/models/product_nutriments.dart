import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:hive/hive.dart';

part 'product_nutriments.g.dart';

@HiveType(typeId: 2)
class ProductNutriments {
  @HiveField(0)
  Map<String, dynamic> energyKJ;

  @HiveField(1)
  Map<String, dynamic> energyKcal;

  @HiveField(2)
  Map<String, dynamic> fat;

  @HiveField(3)
  Map<String, dynamic> saturatedFat;

  @HiveField(4)
  Map<String, dynamic> carbohydrates;

  @HiveField(5)
  Map<String, dynamic> sugars;

  @HiveField(6)
  Map<String, dynamic> proteins;

  @HiveField(7)
  Map<String, dynamic> salt;

  ProductNutriments({
    required this.energyKJ,
    required this.energyKcal,
    required this.fat,
    required this.saturatedFat,
    required this.carbohydrates,
    required this.sugars,
    required this.proteins,
    required this.salt,
  });

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
      salt: saltFromJson,
    );
  }

  Widget renderTable() {
    var nutriments = [
      ("energia [KJ]", energyKJ),
      ("energia [kcal]", energyKcal),
      ("tłuszcz", fat),
      ("kwasy nasycone", saturatedFat),
      ("węglowodany", carbohydrates),
      ("cukry", sugars),
      ("białko", proteins),
      ("sól", salt)
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tabela może zawierać wartości przybliżone",
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 5),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
          },
          border: TableBorder.symmetric(
            inside: const BorderSide(color: greyBg),
          ),
          children: [
            TableRow(children: [
              Container(
                color: green,
                padding: const EdgeInsets.all(5),
                child: const Text(
                  "wartość odżywcza",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
              ),
              Container(
                color: green,
                padding: const EdgeInsets.all(5),
                child: const Text(
                  "w porcji",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
              ),
              Container(
                color: green,
                padding: const EdgeInsets.all(5),
                child: const Text(
                  "w 100 g/ml",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
              )
            ])
          ],
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
          },
          border: TableBorder.symmetric(
            inside: const BorderSide(color: greyBg),
          ),
          children: nutriments
              .map(
                (nutr) => TableRow(
                  children: [
                    Container(
                      color: nutriments.indexOf(nutr) % 2 == 0
                          ? greyBg
                          : greyButton,
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        nutr.$1,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Container(
                      color: nutriments.indexOf(nutr) % 2 == 0
                          ? greyBg
                          : greyButton,
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        nutr.$2["value"],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Container(
                      color: nutriments.indexOf(nutr) % 2 == 0
                          ? greyBg
                          : greyButton,
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        nutr.$2["value_100g"],
                        style: const TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              )
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
