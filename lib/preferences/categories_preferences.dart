import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_budget/model/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesPreferences {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setCategories(List<Category> categories) async {
    var encoded = jsonEncode(categories);
    await _preferences.setString('categories', encoded);
  }

  static List<Category> getCategories() {
    String encoded = _preferences.getString('categories') ?? '';
    if (encoded == '') {
      return [];
    }
    Iterable decodedString = jsonDecode(encoded);

    return List<dynamic>.from(decodedString)
        .map((model) => Category.fromJson(model))
        .toList();
  }
}