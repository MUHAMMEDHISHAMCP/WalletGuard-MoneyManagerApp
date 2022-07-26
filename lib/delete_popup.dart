import 'package:flutter/material.dart';
import 'package:money_manager/dbfunctions/category_db.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/home_screen.dart';
import 'package:money_manager/utilities.dart';

showDeletePopup(BuildContext context, {categoryId, id}) {
  // final selectedId = categoryId;
  // final tarnsactionId = id;
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          // backgroundColor: maincolor,
          title: const Text('Alert !!'),
          content: const Text('Are you sure to want to delete ??'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                if (id != null) {
                  TransactionDB.instance.deleteTransaction(id);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: ((context) => HomeScreen())),
                      (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      'Deleted Successfully',
                      style: popupStyle,
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: deleteColor,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    duration: Duration(seconds: 1),
                  ));
                } else if (categoryId != null) {
                  CategoryDB.instance.deleteCategory(categoryId);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Category Deleted',
                        style: popupStyle,
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: deleteColor,
                      behavior: SnackBarBehavior.floating,
                      margin:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      duration: Duration(seconds: 1)));
                }
              },
              child: const Text('Yes'),
            ),
          ],
        );
      });
}
