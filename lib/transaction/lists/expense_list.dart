import 'package:flutter/material.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/transaction/lists/sort_logic.dart';
import 'package:money_manager/transaction/recent_transaction.dart';
import 'package:money_manager/utilities.dart';

class ExpenseTransactionList extends StatefulWidget {
  const ExpenseTransactionList({Key? key}) : super(key: key);

  @override
  State<ExpenseTransactionList> createState() => _ExpenseTransactionListState();
}

class _ExpenseTransactionListState extends State<ExpenseTransactionList> {
  DateTime? selectedDate;

  List<SortData> _data =
      chatLogic(TransactionDB.instance.expenseTransactionNotifier.value);
  List<SortData> _todayData = chatLogic(
      TransactionDB.instance.todayExpenseTransactionNotifierChart.value);
  List<SortData> _yesterdayData = chatLogic(
      TransactionDB.instance.yesterdayexpenseTransactionNotifierChart.value);
  List<SortData> _weeklyData = chatLogic(
      TransactionDB.instance.weeklyExpenseTransactionNotifierChart.value);
  List<SortData> _MonthlyData = chatLogic(
      TransactionDB.instance.monthlyExpenseTransactionNotifierChart.value);

  String? _selectedItem;
  final _items = ['All', 'Today', 'Yesterday','Last 7 Days', 'Last 30 Days'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2.5,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black45)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                        alignment: Alignment.bottomCenter,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          'All',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        value: _selectedItem,
                        items: _items.map(buildMenuItems).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedItem = newValue.toString();
                          });
                        }),
                  ),
                ),
              ),
              chartChecking().isEmpty
                  ? Expanded(
                      child: Center(
                          child: Text(
                      'No Transaction Data',
                      style: EmptyStyle,
                    )))
                  : Expanded(
                      child: ValueListenableBuilder(
                          valueListenable:
                              TransactionDB.instance.expenseTransactionNotifier,
                          builder: (BuildContext context,
                              List<TransactionModel> newlist, Widget? _) {
                            return newlist.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Transaction Data',
                                      style: EmptyStyle,
                                    ),
                                  )
                                : ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: ((context, index) {
                                      final _transactions = newlist[index];

                                      return TransactionDetails(
                                        transactionData: _transactions,
                                        index: index,
                                      );
                                    }),
                                    itemCount: chartChecking().length,
                                  );
                          }),
                    ),
            ],
          )),
    );
  }

  List<SortData> chartChecking() {
    if (_selectedItem == "All") {
      return _data;
    } else if (_selectedItem == "Today") {
      return _todayData;
    } else if (_selectedItem == "Yesterday") {
      return _yesterdayData;
    } else if (_selectedItem == "Last 7 Days") {
      return _weeklyData;
    } else if (_selectedItem == "Last 30 Days") {
      return _MonthlyData;
    } else {
      return _data;
    }
  }

  DropdownMenuItem<String> buildMenuItems(String item) {
    return DropdownMenuItem(
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      value: item,
    );
  }
}
