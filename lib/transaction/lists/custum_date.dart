import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/transaction/recent_transaction.dart';
import 'package:money_manager/utilities.dart';

// ignore: must_be_immutable
class CustumDate extends StatelessWidget {
  bool text;
  DateTime selectedDateorMonth;
  CustumDate({Key? key, required this.selectedDateorMonth, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text == false
            ? DateFormat.yMMMMd().format(selectedDateorMonth)
            : DateFormat.yMMMM().format(selectedDateorMonth)),
        centerTitle: true,
        backgroundColor: maincolor,
      ),
      body: ValueListenableBuilder(
          valueListenable: TransactionDB.instance.transactionNotifier,
          builder: (BuildContext context, List<TransactionModel> newlist,
              Widget? _) {
            return text == false
                ? newlist
                        .where((element) =>
                            DateFormat.yMMMMd().format(element.date) ==
                            DateFormat.yMMMMd().format(selectedDateorMonth))
                        .toList()
                        .isEmpty
                    ? Center(
                        child: Text(
                        'No Transactions Data ',
                        style: EmptyStyle,
                      ))
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: ((context, index) {
                            final _transactions = newlist[index];

                            return DateFormat.yMMMMd()
                                        .format(_transactions.date) ==
                                    DateFormat.yMMMMd()
                                        .format(selectedDateorMonth)
                                ? TransactionDetails(
                                    transactionData: _transactions,
                                    index: index,
                                  )
                                : SizedBox();
                          }),
                          itemCount: newlist.length,
                        ),
                      )
                : newlist
                        .where((element) =>
                            DateFormat.yMMMM().format(element.date) ==
                            DateFormat.yMMMM().format(selectedDateorMonth))
                        .toList()
                        .isEmpty
                    ? Center(
                        child: Text(
                        'No Transactions Data ',
                        style: EmptyStyle,
                      ))
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: ((context, index) {
                            final _transactions = newlist[index];

                            return DateFormat.yMMMM()
                                        .format(_transactions.date) ==
                                    DateFormat.yMMMM()
                                        .format(selectedDateorMonth)
                                ? TransactionDetails(
                                    transactionData: _transactions,
                                    index: index,
                                  )
                                : SizedBox();
                          }),
                          itemCount: newlist.length,
                        ),
                      );
          }),
    );
  }
}
