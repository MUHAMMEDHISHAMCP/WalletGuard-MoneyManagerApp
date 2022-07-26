// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/category_model.dart';
import 'package:money_manager/models/transaction_model.dart';

const TRANSACTION_DB = 'transacton_database';

abstract class TransactionDbFunctions {
  Future<void> addTransactionDetials(TransactionModel obj);
  Future<void> deleteTransaction(String id);
  Future<List<TransactionModel>> getAllCategories();
  Future<void> updateDetails(TransactionModel value);
    Future<void> resetApp();

}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionNotifier = ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> incomeTransactionNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> expenseTransactionNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> transactionNotifierchart =
      ValueNotifier([]);
 ValueNotifier<List<TransactionModel>> todayTransactionNotifierChart =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> yesterdayTransactionNotifierChart =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> monthlyTransactionNotifierChart =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> weeklyTransactionNotifierChart =
      ValueNotifier([]);

ValueNotifier<List<TransactionModel>> todayInconeTransactionNotifierChart =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>>
      yesterdayIncomeTransactionNotifierChart = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> weeklyIncomeTransactionNotifierChart =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> monthlyIncomeTransactionNotifierChart =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> todayExpenseTransactionNotifierChart =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>>
      yesterdayexpenseTransactionNotifierChart = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> weeklyExpenseTransactionNotifierChart =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> monthlyExpenseTransactionNotifierChart =
      ValueNotifier([]);

  ValueNotifier<double> totolBalanceNotifier = ValueNotifier(0);
  ValueNotifier<double> incomeBalanceNotifier = ValueNotifier(0);
  ValueNotifier<double> expenseBalanceNotifier = ValueNotifier(0);

  @override
  Future<void> addTransactionDetials(TransactionModel obj) async {
    final _transactionDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    _transactionDb.put(obj.id, obj);
    refeshUI();
  }

  @override
  Future<List<TransactionModel>> getAllCategories() async {
    final _transactionDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    return _transactionDb.values.toList();
  }

  refeshUI() async {
    final _list = await getAllCategories();

    _list.sort((a, b) => b.date.compareTo(a.date));
    transactionNotifier.value.clear();
    incomeTransactionNotifier.value.clear();
    expenseTransactionNotifier.value.clear();
    todayInconeTransactionNotifierChart.value.clear();
    yesterdayIncomeTransactionNotifierChart.value.clear();
    weeklyIncomeTransactionNotifierChart.value.clear();
    monthlyIncomeTransactionNotifierChart.value.clear();
    monthlyTransactionNotifierChart.value.clear();
    weeklyTransactionNotifierChart.value.clear();
    yesterdayTransactionNotifierChart.value.clear();
    todayTransactionNotifierChart.value.clear();
    transactionNotifierchart.value.clear();
    todayExpenseTransactionNotifierChart.value.clear();
    yesterdayexpenseTransactionNotifierChart.value.clear();
    weeklyExpenseTransactionNotifierChart.value.clear();
    monthlyExpenseTransactionNotifierChart.value.clear();
    transactionNotifierchart.value.addAll(_list);

  transactionNotifier.value.addAll(_list);

   

    totolBalanceNotifier.value = 0;
    incomeBalanceNotifier.value = 0;
    expenseBalanceNotifier.value = 0;

    String todayDate = DateFormat.yMd().format(DateTime.now());
    String yesterDay =
        DateFormat.yMd().format(DateTime.now().subtract(Duration(days: 1)));

    await Future.forEach(_list, (TransactionModel model) {
      if (model.type == CategoryType.income) {
        incomeBalanceNotifier.value =
            incomeBalanceNotifier.value + model.amount;
      } else {
        expenseBalanceNotifier.value =
            expenseBalanceNotifier.value + model.amount;
      }
      totolBalanceNotifier.value =
          incomeBalanceNotifier.value - expenseBalanceNotifier.value;

      if (model.type == CategoryType.income) {
        incomeTransactionNotifier.value.add(model);
      } else {
        expenseTransactionNotifier.value.add(model);
      }

      String dataBaseDate = DateFormat.yMd().format(model.date);

      if (model.type == CategoryType.income) {
        if (dataBaseDate == todayDate) {
          todayInconeTransactionNotifierChart.value.add(model);
        }
        if (dataBaseDate == yesterDay) {
          yesterdayIncomeTransactionNotifierChart.value.add(model);
        }
        if (model.date.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
          weeklyIncomeTransactionNotifierChart.value.add(model);
        }
        if (model.date.isAfter(DateTime.now().subtract(Duration(days: 30)))) {
          monthlyIncomeTransactionNotifierChart.value.add(model);
        }
      }

      if (model.type == CategoryType.expense) {
        if (dataBaseDate == todayDate) {
          todayExpenseTransactionNotifierChart.value.add(model);
        }
        if (dataBaseDate == yesterDay) {
          yesterdayexpenseTransactionNotifierChart.value.add(model);
        }
        if (model.date.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
          weeklyExpenseTransactionNotifierChart.value.add(model);
        }
        if ( model.date.isAfter(DateTime.now().subtract(Duration(days: 30)))
) {
          monthlyExpenseTransactionNotifierChart.value.add(model);
        }
      }
      if (dataBaseDate == todayDate) {
        todayTransactionNotifierChart.value.add(model);
      }
      if (dataBaseDate == yesterDay) {
        yesterdayTransactionNotifierChart.value.add(model);
      }
      if (model.date.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
        weeklyTransactionNotifierChart.value.add(model);
      }
      if (model.date.isAfter(DateTime.now().subtract(Duration(days: 30)))) {
        monthlyTransactionNotifierChart.value.add(model);
      }
    });

    transactionNotifier.notifyListeners();
    totolBalanceNotifier.notifyListeners();
    incomeBalanceNotifier.notifyListeners();
    expenseBalanceNotifier.notifyListeners();
    incomeTransactionNotifier.notifyListeners();
    expenseTransactionNotifier.notifyListeners();
    todayExpenseTransactionNotifierChart.notifyListeners();
    todayInconeTransactionNotifierChart.notifyListeners();
    yesterdayIncomeTransactionNotifierChart.notifyListeners();
    weeklyIncomeTransactionNotifierChart.notifyListeners();
    monthlyIncomeTransactionNotifierChart.notifyListeners();
    monthlyExpenseTransactionNotifierChart.notifyListeners();
    weeklyExpenseTransactionNotifierChart.notifyListeners();
    yesterdayexpenseTransactionNotifierChart.notifyListeners();
    todayExpenseTransactionNotifierChart.notifyListeners();
    monthlyTransactionNotifierChart.notifyListeners();
    weeklyTransactionNotifierChart.notifyListeners();
    yesterdayTransactionNotifierChart.notifyListeners();
    todayTransactionNotifierChart.notifyListeners();
    transactionNotifierchart.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(id) async {
    final _transactionDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    await _transactionDb.delete(id);
    refeshUI();
  }

  @override
  Future<void> updateDetails(value) async {
    final _transactionDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    await _transactionDb.put(value.id, value);
    // transactionNotifier.notifyListeners();
    refeshUI();
  }
  
  @override
  Future<void> resetApp() async{
        final _transactionDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
  _transactionDb.clear();
  }

}
