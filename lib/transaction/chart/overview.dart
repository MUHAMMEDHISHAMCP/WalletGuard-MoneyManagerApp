import 'package:flutter/material.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/transaction/chart/chart_logic.dart';
import 'package:money_manager/utilities.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverviewChart extends StatefulWidget {
  const OverviewChart({Key? key}) : super(key: key);

  @override
  State<OverviewChart> createState() => _OverviewChartState();
}

class _OverviewChartState extends State<OverviewChart> {
  List<ChartData> _data =
      chatLogic(TransactionDB.instance.transactionNotifierchart.value);
  List<ChartData> _todayData = chatLogic(
      TransactionDB.instance.todayTransactionNotifierChart.value);
  List<ChartData> _yesterdayData = chatLogic(
      TransactionDB.instance.yesterdayTransactionNotifierChart.value);
  List<ChartData> _weeklyData = chatLogic(
      TransactionDB.instance.weeklyTransactionNotifierChart.value);
  List<ChartData> _MonthlyData = chatLogic(
      TransactionDB.instance.monthlyTransactionNotifierChart.value);

  String? _selectedItem;
  final _lists = ['All', 'Today', 'Yesterday', 'Last 7 Days', 'Last 30 Days'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _data.isEmpty
            ? Center(
                child: Text(
                  'No Transaction Data',
                  style: EmptyStyle,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(

                          border: Border.all(color: Colors.black45)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButton(
                            alignment: Alignment.bottomCenter,
                            underline: const SizedBox(),
                            hint: Text(
                              'All',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            value: _selectedItem,
                            isExpanded: true,
                            items: _lists.map(buildMenuItems).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedItem = newValue.toString();
                              });
                            }),
                      ),
                    ),
                  ),
             chartChecking().isEmpty ? Expanded(child: Center(child: Text('No Transaction Data' ,style: EmptyStyle,))):     SfCircularChart(
                    legend: Legend(isVisible: true),
                    series: <CircularSeries>[
                      PieSeries<ChartData, String>(
                        // explode: true,
                        // explodeIndex: 3,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                        ),
                        dataSource: chartChecking(),
                        xValueMapper: (ChartData data, _) => data.categories,
                        yValueMapper: (ChartData data, _) => data.amount,
                        explode: true,
                       
                      )
                    ],
                  ),
                ],
              ));
  }

  List<ChartData> chartChecking() {
    if (_selectedItem == "All") {
      return _data;
    } else if (_selectedItem == "Today") {
      return _todayData;
    } else if (_selectedItem == "Yesterday") {
      return _yesterdayData;
    } else if (_selectedItem == "Last 7 Days") {
      return _weeklyData;
    } else if (_selectedItem == 'Last 30 Days') {
      return _MonthlyData;
    } else {
      return _data;
    }
  }

  DropdownMenuItem<String> buildMenuItems(String item) {
    return DropdownMenuItem(
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      value: item,
    );
  }
}
