import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/model/category.dart';
import 'package:my_budget/model/expense.dart';
import 'package:my_budget/preferences/budget_preferences.dart';
import 'package:my_budget/preferences/categories_preferences.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {

  double totalIncome = 0;
  double totalExpense = 0;
  List<Category> categories = [];
  List<Expense> expenses = [];

  final formatCurrency = NumberFormat("#,##0.00", "pl_PL");

  @override
  void initState() {
    super.initState();
    totalIncome = BudgetPreferences.getIncome();
    expenses = BudgetPreferences.getExpenses();
    totalExpense = expenses.fold(0, (sum, element) => sum + element.value);
    categories = CategoriesPreferences.getCategories();
  }

  double getCategoryValue(Category category) {
    return expenses.where((e) => e.category.name == category.name).toList().fold(0, (sum, element) => sum + element.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'PLN    ',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color(0xFF26C6DA)
                            ),
                          ),
                          Text(
                            formatCurrency.format(totalIncome),
                            style: const TextStyle(
                                fontSize: 28.0,
                                color: Color(0xFF26C6DA)
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Przychody", style: TextStyle(fontSize: 20))
                    )
                  ],
                )
              ),
              Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'PLN    ',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFF26C6DA)
                              ),
                            ),
                            Text(
                              formatCurrency.format(totalExpense),
                              style: const TextStyle(
                                  fontSize: 28.0,
                                  color: Color(0xFF26C6DA)
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Wydatki", style: TextStyle(fontSize: 20))
                      )
                    ],
                  )
              ),
              Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'PLN    ',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFF26C6DA)
                              ),
                            ),
                            Text(
                              formatCurrency.format(totalIncome - totalExpense),
                              style: const TextStyle(
                                  fontSize: 28.0,
                                  color: Color(0xFF26C6DA)
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Bilans", style: TextStyle(fontSize: 20))
                      )
                    ],
                  )
              ),
              Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text("Limity",style: TextStyle(fontSize: 30, color: Colors.white))
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ),
              Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                      categories.asMap().map((int index, Category category) => MapEntry(index, Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(categories[index].name + ': ' + formatCurrency.format(getCategoryValue(categories[index])) + ' / ' + formatCurrency.format(categories[index].limit) + ' PLN', style: const TextStyle(fontSize: 18, color: Color(0xFF26C6DA)))
                            ],
                          ),
                        )
                      )
                    ).values.toList()
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(children: [
                  ElevatedButton(
                      onPressed: () async {
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Reset stanu aplikacji'),
                            content: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: const [
                                        Expanded(child: Text('Czy na pewno chcesz zresetować stan aplikacji? Spowoduje to usunięcie wszystkich danych.'))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            actions: [
                              ElevatedButton(onPressed: () async {
                                Navigator.of(context).pop();
                              }, child: const Text('Nie')),
                              ElevatedButton(onPressed: () async {
                                await CategoriesPreferences.setCategories([]);
                                await BudgetPreferences.setIncome(0);
                                await BudgetPreferences.setExpenses([]);
                                setState(() {
                                  totalIncome = BudgetPreferences.getIncome();
                                  expenses = BudgetPreferences.getExpenses();
                                  totalExpense = expenses.fold(0, (sum, element) => sum + element.value);
                                  categories = CategoriesPreferences.getCategories();
                                });
                                Navigator.of(context).pop();
                              }, child: const Text('Tak'))
                            ],
                          );
                        });
                      },
                      child: const Text('Resetuj stan aplikacji'),
                      style: ElevatedButton.styleFrom(fixedSize: const Size(240, 80), primary: Colors.red)
                  ),
                ]),
              )
            ],
          ),
        )
    );
  }
}
