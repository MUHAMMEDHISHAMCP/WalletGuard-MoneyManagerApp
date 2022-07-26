import 'package:money_manager/models/transaction_model.dart';

class SortData {
  String categories;
  double amount;

  SortData({required this.categories, required this.amount});
}

chatLogic(List<TransactionModel> model) {
  double value;
  String categoryName;
  List visited = [];
  List<SortData> newData = [];

  for (var i = 0; i < model.length; i++) {
    visited.add(0);
  }

  for (var i = 0; i < model.length; i++) {
    value = model[i].amount;
    categoryName = model[i].categry.name;
    newData.add(SortData(categories: categoryName, amount: value));
  }
  return newData;
}
