import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/model/category.dart';
import 'package:my_budget/preferences/categories_preferences.dart';
import 'package:my_budget/util/decimal_text_input_formatter.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  String inputCategory = '';
  double inputLimit = 0.0;
  List<Category> categories = [];

  final formatCurrency = NumberFormat("#,##0.00", "pl_PL");

  @override
  void initState() {
    categories = CategoriesPreferences.getCategories();
    super.initState();
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(label: Text(column));
    }).toList();
  }

  List<DataRow> getRows() {
    return categories.map((category) => DataRow(
          cells: <DataCell>[
            DataCell(Text(category.name)),
            DataCell(Text(formatCurrency.format(category.limit))),
            DataCell(ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edytuj kategorię',
                onPressed: () {
                  editCategory(category);
                },
              ),
            )
            ),
            DataCell(ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Usuń kategorię',
                onPressed: () {
                  deleteCategory(category);
                },
              )
            )
            )
          ]
        )).toList();
  }

  Future editCategory(Category category) async {
    String newName = '';
    double newLimit = 0;
    await showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edycja kategorii'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                      initialValue: category.name,
                      decoration: const InputDecoration(
                          hintText: 'Nazwa kategorii'
                      ),
                      onChanged: (String value) {
                        newName = value;
                      },
                    )
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: category.limit.toString(),
                      inputFormatters: [DecimalTextInputFormatter()],
                      decoration: const InputDecoration(
                          hintText: 'Limit kategorii'
                      ),
                      onChanged: (String value) {
                        newLimit = double.parse(value);
                      },
                    )
                )
              ],
            )
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () async {
            category.name = newName == '' ? category.name : newName;
            category.limit = newLimit == 0 ? category.limit : newLimit;
            await CategoriesPreferences.setCategories(categories);
            setState(() {
              categories = CategoriesPreferences.getCategories();
            });
            Navigator.of(context).pop();
          }, child: const Text('Zapisz'))
        ],
      );
    });
  }

  Future deleteCategory(Category category) async {
    categories.remove(category);
    await CategoriesPreferences.setCategories(categories);
    setState(() {
      categories = CategoriesPreferences.getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: getColumns(['Nazwa', 'Limit (PLN)', '', '']),
              rows: getRows(),
            )
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Nowa kategoria'),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: 'Nazwa kategorii'
                          ),
                          onChanged: (String value) {
                            inputCategory = value;
                          },
                        )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [DecimalTextInputFormatter()],
                          decoration: const InputDecoration(
                              hintText: 'Limit kategorii'
                          ),
                          onChanged: (String value) {
                            inputLimit = double.parse(value);
                          },
                        )
                      )
                    ],
                  )
                ],
              ),
              actions: [
                ElevatedButton(onPressed: () async {
                  setState(() {
                    categories.add(Category(name: inputCategory, limit: inputLimit));
                  });
                  await CategoriesPreferences.setCategories(categories);
                  Navigator.of(context).pop();
                }, child: const Text('Dodaj'))
              ],
            );
          });
        },
        child: const Icon(
          Icons.add_box,
          color: Colors.white,
        )
      ),
    );
  }
}
