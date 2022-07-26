import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/dbfunctions/category_db.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/transaction/add_transaction.dart';
import 'package:money_manager/transaction/card_overview.dart';
import 'package:money_manager/transaction/lists/transaction_list.dart';
import 'package:money_manager/transaction/recent_transaction.dart';
import 'package:money_manager/utilities.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refeshUI();
    CategoryDB.instance.refreshUI();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: maincolor,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(
          children: [
            TrannsactionView(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => const FullTransactionList())));
                    },
                    child: const Text(
                      'View All ▶',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: TransactionDB.instance.transactionNotifier,
                    builder: (BuildContext context,
                        List<TransactionModel> newlist, Widget? _) {
                      return newlist.isEmpty
                          ? GestureDetector(
                              onTap: (() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const AddTransactionScreen())));
                              }),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      'assets/undraw_add_files_re_v09g (1).svg',
                                      width:
                                          MediaQuery.of(context).size.height /
                                              4.5),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Add Transactions',
                                    style: EmptyStyle,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
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
                              itemCount:
                                  (newlist.length <= 6) ? newlist.length : 5,
                            );
                    }))
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const AddTransactionScreen())));
          },
          backgroundColor: maincolor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitdate = _date.split(' ');
    return '${_splitdate.last}\n${_splitdate.first}';
  }
}
