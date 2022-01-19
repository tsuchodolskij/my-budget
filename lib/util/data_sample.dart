import 'package:flutter/material.dart';
import 'package:my_budget/model/category.dart';
import 'package:my_budget/model/expense.dart';
import 'package:my_budget/preferences/budget_preferences.dart';
import 'package:my_budget/preferences/categories_preferences.dart';

class DataSample {

  static Future mock() async {

    List<Category> categories = [];

    categories.add(Category(name: 'Mieszkanie', limit: 1000));
    categories.add(Category(name: 'Pożywienie', limit: 500));
    categories.add(Category(name: 'Treningi', limit: 400));
    categories.add(Category(name: 'Imprezy', limit: 5000));
    categories.add(Category(name: 'Inne', limit: 500));

    await CategoriesPreferences.setCategories(categories);

    List<Expense> expenses = [];

    expenses.add(Expense(value: 250, category: categories[0]));
    expenses.add(Expense(value: 50, category: categories[1]));
    expenses.add(Expense(value: 40, category: categories[4]));
    expenses.add(Expense(value: 20, category: categories[4]));
    expenses.add(Expense(value: 200, category: categories[1]));
    expenses.add(Expense(value: 120, category: categories[3]));
    expenses.add(Expense(value: 10, category: categories[0]));
    expenses.add(Expense(value: 15.50, category: categories[1]));
    expenses.add(Expense(value: 190.90, category: categories[2]));
    expenses.add(Expense(value: 20.45, category: categories[1]));
    expenses.add(Expense(value: 163.29, category: categories[3]));
    expenses.add(Expense(value: 600, category: categories[3]));

    await BudgetPreferences.setExpenses(expenses);

    await BudgetPreferences.setIncome(2000);
  }
}