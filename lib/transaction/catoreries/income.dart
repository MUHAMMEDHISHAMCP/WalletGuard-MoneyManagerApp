import 'package:flutter/material.dart';
import 'package:money_manager/dbfunctions/category_db.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/delete_popup.dart';
import 'package:money_manager/models/category_model.dart';
import 'package:money_manager/transaction/catoreries/add_popup.dart';
import 'package:money_manager/utilities.dart';

class IncomeCatogery extends StatelessWidget {
  const IncomeCatogery({Key? key}) : super(key: key);
  final _type = CategoryType.income;
  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refeshUI();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AddPopup(
                        type: _type,
                      );
                    }).then((value) {
                  TransactionDB.instance.refeshUI();
                });
              },
              style: ElevatedButton.styleFrom(
                primary: optionalcolor,
              ),
              child: const Text('+ Add Category'),
            ),
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: CategoryDB().incomeCategoryList,
                    builder: (BuildContext context, List<CategoryModel> newList,
                        Widget? _) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: newList.isEmpty
                            ? Center(
                                child: Text(
                                'No Categories added',
                                style: EmptyStyle,
                              ))
                            : GridView.builder(
                                itemCount: newList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: MediaQuery.of(context)
                                                .size
                                                .width /
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                5),
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5),
                                itemBuilder: (contex, index) {
                                  final catogery = newList[index];
                                  return InkWell(
                                    onLongPress: () {
                                      showDeletePopup(context,
                                          categoryId: catogery.id);
                                    },
                                    child: newList.isEmpty
                                        ? Center(
                                            child: Text('No Categories added'))
                                        : Card(
                                            color: categorycolor,
                                            elevation: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: FittedBox(
                                                  child: Text(
                                                    catogery.name.toUpperCase(),
                                                    style: TextStyle(
                                                        color: incomecolor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            'categoryFont'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                  );
                                }),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
