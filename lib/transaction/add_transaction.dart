import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_manager/dbfunctions/category_db.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/home_screen.dart';
import 'package:money_manager/models/category_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/transaction/catoreries/add_popup.dart';
import 'package:money_manager/utilities.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final notesEditController = TextEditingController();
  final amountEditController = TextEditingController();
  String counterText = '0';

  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _SelectedCategory;

  String? _categoryID;
  String? selectedValue;

  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.clear),
            color: optionalcolor,
          ),
          backgroundColor: subcolor,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/undraw_add_files_re_v09g (1).svg',
                    height: 170,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Add Transaction',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: CategoryType.income,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategoryType = CategoryType.income;
                                _categoryID = null;
                                _SelectedCategory = null;
                              });
                            },
                            activeColor: maincolor,
                          ),
                          const Text('Income')
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: CategoryType.expense,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategoryType = CategoryType.expense;
                                _categoryID = null;
                                _SelectedCategory = null;
                              });
                            },
                            activeColor: Colors.teal.shade400,
                          ),
                          const Text('Expense')
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 30 * 5)),
                          lastDate: DateTime.now());
                      if (selectedDate == null) {
                        return;
                      } else {
                        setState(() {
                          _selectedDate = selectedDate;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.teal.shade400,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _selectedDate == null
                                ? const Text(
                                    'Select Date',
                                    style: TextStyle(color: maincolor),
                                  )
                                : Text('  ${_selectedDate?.day} - '
                                    '${_selectedDate?.month} - '
                                    '${_selectedDate?.year}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: amountEditController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Amount',
                        counterText: '',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                        suffixText: '${counterText}/12'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                    maxLength: 12,
                    onChanged: (value) {
                      setState(() {
                        counterText = value.length.toString();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButton(
                              underline: const SizedBox(),
                              hint: Text('Select Category'),
                              value: _categoryID,
                              items:
                                  (_selectedCategoryType == CategoryType.income
                                          ? CategoryDB().incomeCategoryList
                                          : CategoryDB().expenseCategoryList)
                                      .value
                                      .map((e) {
                                return DropdownMenuItem(
                                  value: e.id,
                                  child: Text(e.name),
                                  onTap: () {
                                    _SelectedCategory = e;
                                  },
                                );
                              }).toList(),
                              onChanged: (selectedValue) {
                                setState(() {
                                  _categoryID = selectedValue.toString();
                                });
                              }),
                        ),
                        Container(
                          color: maincolor,
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AddPopup(
                                        type: _selectedCategoryType!,
                                      );
                                    }).then((value) {
                                  setState(() {
                                    TransactionDB.instance.refeshUI();
                                  });
                                });
                              },
                              icon: Icon(Icons.add)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: notesEditController,
                    decoration: const InputDecoration(
                      errorMaxLines: 5,
                      hintText: 'Notes',
                      // counterText: '',
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                    ),
                    // maxLength: 12,
                    minLines: 2,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        addTransaction();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 30),
                        primary: maincolor,
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  addTransaction() async {
    final amountText = amountEditController.text;
    final notesText = notesEditController.text;
    if (amountText.isEmpty ||
        _selectedDate == null ||
        _SelectedCategory == null ||
        _selectedCategoryType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please Fill All Fields',
          textAlign: TextAlign.center,
        ),
        backgroundColor: deleteColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      ));
    } else {
      final parsedAmount = double.tryParse(amountText);
      if (parsedAmount == null) {
        return;
      } else if (parsedAmount == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Enter Correct Amount',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.yellow.shade200,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          duration: Duration(seconds: 3),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Added Successfully',
            style: popupStyle,
            textAlign: TextAlign.center,
          ),
          backgroundColor: maincolor,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          duration: Duration(seconds: 3),
        ));
        final _transactionModel = TransactionModel(
            amount: parsedAmount,
            notes: notesText,
            date: _selectedDate!,
            categry: _SelectedCategory!,
            type: _selectedCategoryType!,
            id: DateTime.now().millisecondsSinceEpoch.toString());
        TransactionDB.instance.addTransactionDetials(_transactionModel);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: ((context) => HomeScreen())),
            (route) => false);
      }
    }
  }
}
