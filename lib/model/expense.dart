import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_budget/model/category.dart';

part 'expense.g.dart';

@JsonSerializable(explicitToJson: true)
class Expense {
  double value;
  Category category;

  Expense({required this.value, required this.category});

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}
