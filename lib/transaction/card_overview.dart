import 'package:flutter/material.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrannsactionView extends StatefulWidget {
  TrannsactionView({Key? key}) : super(key: key);

  @override
  State<TrannsactionView> createState() => _TrannsactionViewState();
}

class _TrannsactionViewState extends State<TrannsactionView> {
  ValueNotifier<List<String>> userName = ValueNotifier([]);

  String name = '';

  getName() async {
    final pref = await SharedPreferences.getInstance();
    name = await pref.getString('savedValue').toString();
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      semanticContainer: true,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 48, 172, 160),
                    Color.fromARGB(255, 182, 180, 180),
                  ],
                  begin: FractionalOffset.bottomRight,
                  end: FractionalOffset.topLeft,
                  tileMode: TileMode.decal),
              borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7, left: 7),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 5, right: 3),
                        child: Text(
                          'Hello',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2),
                        ),
                      ),
                      ValueListenableBuilder(
                          valueListenable:
                              TransactionDB.instance.totolBalanceNotifier,
                          builder: (BuildContext context, double totatbalance,
                              Widget? child) {
                            return Text(
                              name.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'categoryFont',
                                  letterSpacing: 2),
                            );
                          })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'TOTAL BALANCE',
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'extraFont', letterSpacing: 2),
                ),
                ValueListenableBuilder(
                    valueListenable:
                        TransactionDB.instance.totolBalanceNotifier,
                    builder: (BuildContext context, double totatbalance,
                        Widget? child) {
                      return Text(
                        totatbalance >= 0 ? '₹ $totatbalance' : '₹ 0.0',
                        style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 1,
                            fontFamily: 'cardFont',
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      );
                    }),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'INCOME',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'extraFont',
                                letterSpacing: 1),
                          ),
                          ValueListenableBuilder(
                              valueListenable:
                                  TransactionDB.instance.incomeBalanceNotifier,
                              builder: (BuildContext context,
                                  double incomebalance, Widget? child) {
                                return Text(
                                  '₹ $incomebalance',
                                  style: TextStyle(
                                      color: incomecolor,
                                      fontSize: 20,
                                      letterSpacing: 1,
                                      fontFamily: 'cardFont',
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                );
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Text(
                            'EXPENSE',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'extraFont',
                                letterSpacing: 1),
                          ),
                          ValueListenableBuilder(
                              valueListenable:
                                  TransactionDB.instance.expenseBalanceNotifier,
                              builder: (BuildContext context,
                                  double expensebalance, Widget? child) {
                                return Text(
                                  '₹ $expensebalance',
                                  style: TextStyle(
                                      color: expensecolor,
                                      fontSize: 20,
                                      fontFamily: 'cardFont',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1),
                                );
                              }),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
