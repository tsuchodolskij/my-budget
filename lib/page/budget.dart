import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/model/category.dart';
import 'package:my_budget/model/expense.dart';
import 'package:my_budget/preferences/budget_preferences.dart';
import 'package:my_budget/preferences/categories_preferences.dart';
import 'package:my_budget/util/decimal_text_input_formatter.dart';

class Budget extends StatefulWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {

  double incomeInput = 0;
  double expenseInput = 0;
  String expenseCategoryInput = '';
  List<Expense> expenses = [];
  List<Category> categories = [];

  final formatCurrency = NumberFormat("#,##0.00", "pl_PL");

  @override
  void initState() {
    categories = CategoriesPreferences.getCategories();
    expenses = BudgetPreferences.getExpenses();
    super.initState();
  }

  Widget buildExpenses() {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return buildRow(index);
        }
    );
  }

  Widget buildRow(int index) {
    return ListTile(
        title: Text('${expenses[expenses.length - index - 1].category.name}: ${formatCurrency.format(expenses[expenses.length - index - 1].value)} PLN', style: const TextStyle(fontSize: 18)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Usuń wydatek',
          onPressed: () async {
            expenses.removeAt(expenses.length - index - 1);
            await BudgetPreferences.setExpenses(expenses);
            setState(() {
              expenses = BudgetPreferences.getExpenses();
            });
          },
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
                            child: const Text('Dodaj przychód'),
                            onPressed: () {
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Nowy przychód'),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [DecimalTextInputFormatter()],
                                                decoration: const InputDecoration(
                                                    hintText: 'Podaj kwotę'
                                                ),
                                                onChanged: (String value) {
                                                  incomeInput = double.parse(value);
                                                },
                                              )
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(onPressed: () async {
                                      await BudgetPreferences.addIncome(incomeInput);
                                      incomeInput = 0.0;
                                      Navigator.of(context).pop();
                                    }, child: const Text('Dodaj'))
                                  ],
                                );
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
                            child: const Text('Dodaj wydatek'),
                            onPressed: () {
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Nowy wydatek'),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [DecimalTextInputFormatter()],
                                                decoration: const InputDecoration(
                                                    hintText: 'Podaj kwotę'
                                                ),
                                                onChanged: (String value) {
                                                  expenseInput = double.parse(value);
                                                },
                                              )
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Autocomplete(
                                                optionsBuilder: (TextEditingValue textEditingValue) {
                                                  if (textEditingValue.text.isEmpty) {
                                                    return const Iterable<String>.empty();
                                                  } else {
                                                    return categories.map((e) => e.name).where((word) => word.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                                                  }
                                                },
                                                onSelected: (String value) {
                                                  expenseCategoryInput = value;
                                                },
                                              )
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(onPressed: () async {
                                      Category category = categories.firstWhere((c) => c.name == expenseCategoryInput);
                                      double expensesSum = expenses.where((e) => e.category.name == category.name).toList().fold(0, (sum, element) => sum + element.value);
                                      if (expensesSum + expenseInput > category.limit) {
                                        showDialog(context: context, builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Limit przekroczony'),
                                            content: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: const [
                                                      Expanded(
                                                        child: Text(
                                                          "Został przekroczony limit. Zwiększ limit kategorii i wprowadź wydatek ponownie.", style: TextStyle(fontSize: 18)
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              ElevatedButton(onPressed: () async {
                                                Navigator.of(context).pop();
                                              }, child: const Text('Ok'))
                                            ],
                                          );
                                        });
                                      }
                                      else {
                                        setState(() {
                                          expenses.add(Expense(value: expenseInput, category: category));
                                        });
                                        await BudgetPreferences.setExpenses(expenses);
                                        setState(() {
                                          expenses = BudgetPreferences.getExpenses();
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    }, child: const Text('Dodaj'))
                                  ],
                                );
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: buildExpenses()),
                ],
              ),
            ),
          ],
        )
    );
  }
}
