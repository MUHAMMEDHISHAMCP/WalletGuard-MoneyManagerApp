import 'package:flutter/material.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/transaction/lists/all_transaction.dart';
import 'package:money_manager/transaction/lists/custum_date.dart';
import 'package:money_manager/transaction/lists/expense_list.dart';
import 'package:money_manager/transaction/lists/income_list.dart';
import 'package:money_manager/transaction/lists/search_screen.dart';
import 'package:money_manager/utilities.dart';
import 'package:month_year_picker/month_year_picker.dart';

class FullTransactionList extends StatefulWidget {
  const FullTransactionList({Key? key}) : super(key: key);

  @override
  State<FullTransactionList> createState() => _FullTransactionListState();
}

class _FullTransactionListState extends State<FullTransactionList>
    with SingleTickerProviderStateMixin {
  late TabController _tabcontroller;
  @override
  void initState() {
    _tabcontroller = TabController(length: 3, vsync: this);
    TransactionDB.instance.refeshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refeshUI();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ALL TRANSACTIONS',style: appBarStyle,),
        backgroundColor: maincolor,
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.sort),
            itemBuilder: ((ctx) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text('Select Date'),
                    onTap: () async {},
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text('Select Month'),
                  ),
                ]),
            onSelected: (value) async {
              if (value == 1) {
                final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30 * 5)),
                    lastDate: DateTime.now());
                if (selectedDate == null) {
                  return;
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => CustumDate(
                           selectedDateorMonth: selectedDate,text: false,
                          ))));
                }
              } else if (value == 2) {
                showMonth(context: context, locale: 'en');
              }
            },
          ),
         
          IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) => SearchScreen())));
          }, icon: Icon(Icons.search_outlined))
        ],
      ),
      body: Column(children: [
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
                  text: 'ALL',
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
          child: TabBarView(controller: _tabcontroller, children: [
            AllTransactionList(),
            IncomeTransactionList(),
            ExpenseTransactionList(),
          ]),
        ),
      ]),
    );
  }

  showMonth({required BuildContext context, String? locale}) async {
    final localdate = locale != null ? Locale(locale) : null;

    final selectedMonth = await showMonthYearPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime.now(),
        locale: localdate);
        if(selectedMonth == null){
          return;
        } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => CustumDate(
                            selectedDateorMonth: selectedMonth,text: true,
                          ))));
                }
  }
}
