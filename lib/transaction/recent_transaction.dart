import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/models/category_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/transaction/edit_transaction.dart';
import 'package:money_manager/utilities.dart';

// ignore: must_be_immutable
class TransactionDetails extends StatelessWidget {
TransactionModel transactionData;
  int index;
  TransactionDetails(
      {Key? key, required this.transactionData, required this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refeshUI();
    return GestureDetector(
      onTap: (() {
        Sample.categoryName = transactionData.categry.name;
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) =>
                EditTransactionScreen(data: transactionData, index: index))));
      }),
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: Container(
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                  color: transactionData.type == CategoryType.income
                      ? incomecolor
                      : expensecolor),
            ),
            child: Text(
              parseDate(transactionData.date),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'mainFont',
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),
          title: Text( 
            transactionData.categry.name.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'categoryFont'),
          ),
          subtitle: Text(
            transactionData.notes,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: transactionData.type == CategoryType.income
              ? Text(
                  transactionData.amount.toString(),
                  style: TextStyle(color: incomecolor, fontFamily: 'cardFont',letterSpacing: 1),
                )
              : Text(
                  transactionData.amount.toString(),
                  style: TextStyle(color: expensecolor, fontFamily: 'cardFont',letterSpacing: 1),
                ),
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
