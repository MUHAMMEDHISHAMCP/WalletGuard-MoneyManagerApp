import 'package:flutter/material.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/transaction/chart/expense_chart.dart';
import 'package:money_manager/transaction/chart/income_chart.dart';
import 'package:money_manager/transaction/chart/overview.dart';
import 'package:money_manager/utilities.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> with SingleTickerProviderStateMixin {

late TabController _tabcontroller;
// int currentIndex = 0 ;

@override
  void initState() {
        _tabcontroller = TabController(length: 3, vsync: this);
        TransactionDB.instance.refeshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refeshUI();
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('TRANSACTION STATICS',style: appBarStyle,),
backgroundColor: maincolor,
 shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    unselectedLabelColor: Colors.black,
                    controller: _tabcontroller,
                    indicator: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tabs: const [
                      Tab(
                        text: 'OVERVIEW',
                      ),
                      Tab(
                        text: 'INCOME',
                      ),
                      Tab(
                        text: 'EXPENSE',
                      ),
                    ],
                 
                  ),
                ),
              ),
             
              Expanded(
                child:TabBarView(
                  controller: _tabcontroller,
                  children:[
                    OverviewChart(),
                    IncomeChart(),
                    ExpenseChart(),
                  ] ),),
          ],
        ),
      ),
    );
  }
}