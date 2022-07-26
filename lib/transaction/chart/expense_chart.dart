import 'package:flutter/material.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/transaction/chart/chart_logic.dart';
import 'package:money_manager/utilities.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseChart extends StatefulWidget {
  const ExpenseChart({Key? key}) : super(key: key);

  @override
  State<ExpenseChart> createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  List<ChartData> data =
      chatLogic(TransactionDB.instance.expenseTransactionNotifier.value);
  List<ChartData> _todayExpense = chatLogic(
      TransactionDB.instance.todayExpenseTransactionNotifierChart.value);
  List<ChartData> _yesterdayExpense = chatLogic(
      TransactionDB.instance.yesterdayexpenseTransactionNotifierChart.value);
  List<ChartData> _weeklyExpense = chatLogic(
      TransactionDB.instance.weeklyExpenseTransactionNotifierChart.value);
  List<ChartData> _MonthlyExpense = chatLogic(
      TransactionDB.instance.monthlyExpenseTransactionNotifierChart.value);

  String? _selectedItem;
  final _lists = ['All', 'Today', 'Yesterday', 'Last 7 Days', 'Last 30 Days'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data.isEmpty
          ? Center(
              child: Text(
                'No Transactions Data',
                style: EmptyStyle,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(
                            'All',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          value: _selectedItem,
                          items: _lists.map(buildMenuItems).toList(),
                          onChanged: (selectedValue) {
                            setState(() {
                              _selectedItem = selectedValue.toString();
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
                    : SfCircularChart(
                        legend: Legend(isVisible: true),
                        series: <CircularSeries>[
                          PieSeries<ChartData, String>(
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                            ),
                            dataSource: chartChecking(),
                            xValueMapper: (ChartData data, _) =>
                                data.categories,
                            yValueMapper: (ChartData data, _) => data.amount,
                            explode: true,
                          )
                        ],
                      ),
              ],
            ),
    );
  }

  List<ChartData> chartChecking() {
    if (_selectedItem == "All") {
      return data;
    } else if (_selectedItem == "Today") {
      return _todayExpense;
    } else if (_selectedItem == "Yesterday") {
      return _yesterdayExpense;
    } else if (_selectedItem == "Last 7 Days") {
      return _weeklyExpense;
    } else if (_selectedItem == 'Last 30 Days') {
      return _MonthlyExpense;
    } else {
      return data;
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
