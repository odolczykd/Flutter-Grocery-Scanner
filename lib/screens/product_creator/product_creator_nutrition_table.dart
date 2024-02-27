import 'package:flutter/material.dart';
import 'package:grocery_scanner/models/product_nutriments.dart';
import 'package:grocery_scanner/shared/colors.dart';
import 'package:grocery_scanner/shared/form_text_field.dart';

class ProductCreatorNutritionTable extends StatefulWidget {
  final ProductNutriments? receivedNutriments;
  final Function(ProductNutriments) setValue;
  const ProductCreatorNutritionTable({
    super.key,
    this.receivedNutriments,
    required this.setValue,
  });

  @override
  State<ProductCreatorNutritionTable> createState() =>
      _ProductCreatorNutritionTableState();
}

class _ProductCreatorNutritionTableState
    extends State<ProductCreatorNutritionTable> {
  // final _formKey = GlobalKey<FormState>();

  bool isEditMode = false;
  ProductNutriments nutriments = ProductNutriments(
    energyKJ: _emptyNutriment(),
    energyKcal: _emptyNutriment(),
    fat: _emptyNutriment(),
    saturatedFat: _emptyNutriment(),
    carbohydrates: _emptyNutriment(),
    sugars: _emptyNutriment(),
    proteins: _emptyNutriment(),
    salt: _emptyNutriment(),
  );

  @override
  void initState() {
    super.initState();
    isEditMode = widget.receivedNutriments != null;
    if (isEditMode) nutriments = widget.receivedNutriments!;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2)
      },
      children: [
        // Header
        TableRow(
          children: [
            Container(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "w porcji",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "w 100 g/ml",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),

        // Energy [kJ]
        TableRow(
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "energia [kJ]",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                labelText: "",
                color: green,
                obscureText: false,
                callback: (val) => setState(() {
                  nutriments.energyKJ["value"] = val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode && nutriments.energyKJ["value"] != "N/A")
                    ? nutriments.energyKJ["value"]
                    : "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                labelText: "",
                color: green,
                obscureText: false,
                callback: (val) => setState(() {
                  nutriments.energyKJ["value_100g"] =
                      val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value:
                    (isEditMode && nutriments.energyKJ["value_100g"] != "N/A")
                        ? nutriments.energyKJ["value_100g"]
                        : "",
              ),
            )
          ],
        ),

        // Energy [kcal]
        TableRow(
          decoration: const BoxDecoration(color: greyBg),
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "energia [kcal]",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.energyKcal["value"] =
                      val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode && nutriments.energyKcal["value"] != "N/A")
                    ? nutriments.energyKcal["value"]
                    : "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.energyKcal["value_100g"] =
                      val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value:
                    (isEditMode && nutriments.energyKcal["value_100g"] != "N/A")
                        ? nutriments.energyKcal["value_100g"]
                        : "",
              ),
            )
          ],
        ),

        // Fat
        TableRow(
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "tłuszcz",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.fat["value"] = val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode && nutriments.fat["value"] != "N/A")
                    ? nutriments.fat["value"]
                    : "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.fat["value_100g"] = val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode && nutriments.fat["value_100g"] != "N/A")
                    ? nutriments.fat["value_100g"]
                    : "",
              ),
            )
          ],
        ),

        // Saturated Fat
        TableRow(
          decoration: const BoxDecoration(color: greyBg),
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "kwasy nasycone",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.saturatedFat["value"] =
                      val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode && nutriments.saturatedFat["value"] != "N/A")
                    ? nutriments.saturatedFat["value"]
                    : "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.saturatedFat["value_100g"] =
                      val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode &&
                        nutriments.saturatedFat["value_100g"] != "N/A")
                    ? nutriments.saturatedFat["value_100g"]
                    : "",
              ),
            )
          ],
        ),

        // Carbohydrates
        TableRow(
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "węglowodany",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.carbohydrates["value"] =
                      val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value:
                    (isEditMode && nutriments.carbohydrates["value"] != "N/A")
                        ? nutriments.carbohydrates["value"]
                        : "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.carbohydrates["value_100g"] =
                      val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode &&
                        nutriments.carbohydrates["value_100g"] != "N/A")
                    ? nutriments.carbohydrates["value_100g"]
                    : "",
              ),
            )
          ],
        ),

        // Sugars
        TableRow(
          decoration: const BoxDecoration(color: greyBg),
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "cukry",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.sugars["value"] = val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode && nutriments.sugars["value"] != "N/A")
                    ? nutriments.sugars["value"]
                    : "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.sugars["value_100g"] =
                      val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode && nutriments.sugars["value_100g"] != "N/A")
                    ? nutriments.sugars["value_100g"]
                    : "",
              ),
            )
          ],
        ),

        // Proteins
        TableRow(
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "białko",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.proteins["value"] = val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode && nutriments.proteins["value"] != "N/A")
                    ? nutriments.proteins["value"]
                    : "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.proteins["value_100g"] =
                      val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value:
                    (isEditMode && nutriments.proteins["value_100g"] != "N/A")
                        ? nutriments.proteins["value_100g"]
                        : "",
              ),
            )
          ],
        ),

        // Salt
        TableRow(
          decoration: const BoxDecoration(color: greyBg),
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "sól",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.salt["value"] = val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode && nutriments.salt["value"] != "N/A")
                    ? nutriments.salt["value"]
                    : "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: FormTextField(
                callback: (val) => setState(() {
                  nutriments.salt["value_100g"] = val!.isNotEmpty ? val : "N/A";
                  widget.setValue(nutriments);
                }),
                labelText: "",
                color: green,
                obscureText: false,
                validator: (val) {
                  if (val!.isNotEmpty &&
                      !RegExp(r"([0-9]*[.])?[0-9]+").hasMatch(val)) {
                    return "Zły format";
                  } else {
                    return null;
                  }
                },
                value: (isEditMode && nutriments.salt["value_100g"] != "N/A")
                    ? nutriments.salt["value_100g"]
                    : "",
              ),
            )
          ],
        )
      ],
    );
  }
}

Map<String, dynamic> _emptyNutriment() => {"value": "N/A", "value_100g": "N/A"};
