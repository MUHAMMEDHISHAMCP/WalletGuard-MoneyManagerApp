import 'package:flutter/material.dart';
import 'package:money_manager/dbfunctions/category_db.dart';
import 'package:money_manager/transaction/catoreries/expence.dart';
import 'package:money_manager/transaction/catoreries/income.dart';
import 'package:money_manager/utilities.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabcontroller;
  Color tabColor = Colors.green;

  @override
  void initState() {
    _tabcontroller = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text('CATEGORY',style: appBarStyle,),
          backgroundColor: maincolor,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  unselectedLabelColor: Colors.black,
                  controller: _tabcontroller,
                  indicator: BoxDecoration(
                    color: tabColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tabs: const [
                    Tab(
                      text: 'INCOME',
                    ),
                    Tab(
                      text: 'EXPENSE',
                    ),
                  ],
                  onTap: (index) {
                    setState(() {
                      _tabcontroller.index == 0
                          ? tabColor = Colors.green
                          : tabColor = Colors.red;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabcontroller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    IncomeCatogery(),
                    ExpenseCategory(),
                  ]),
            )
          ],
        ));
  }
}
