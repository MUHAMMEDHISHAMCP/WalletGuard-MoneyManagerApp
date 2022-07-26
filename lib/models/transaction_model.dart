import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final String notes;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final CategoryModel categry;

  @HiveField(4)
  final CategoryType type;

  @HiveField(5)
  String? id;

  TransactionModel(
      {required this.amount,
      required this.notes,
      required this.date,
      required this.categry,
      required this.type,
      this.id});
      }

