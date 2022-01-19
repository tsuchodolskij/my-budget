// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return Expense(
    value: (json['value'] as num).toDouble(),
    category: Category.fromJson(json['category'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'value': instance.value,
      'category': instance.category.toJson(),
    };
