import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_budget/model/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetPreferences {

  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setIncome(double value) async {
    await _preferences.setDouble('income', value);
  }

  static double getIncome() {
    return _preferences.getDouble('income') ?? 0.0;
  }

  static Future addIncome(double value) async {
    double income = getIncome();
    income += value;
    await setIncome(income);
  }

  static Future setExpenses(List<Expense> expenses) async {
    var encoded = jsonEncode(expenses);
    await _preferences.setString('expenses', encoded);
  }

  static List<Expense> getExpenses() {
    String encoded = _preferences.getString('expenses') ?? '';
    if (encoded == '') {
      return [];
    }
    Iterable decodedString = jsonDecode(encoded);

    return List<dynamic>.from(decodedString)
        .map((model) => Expense.fromJson(model))
        .toList();
  }
}