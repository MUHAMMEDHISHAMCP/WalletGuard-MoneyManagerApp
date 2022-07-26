import 'package:flutter/material.dart';
import 'package:money_manager/dbfunctions/category_db.dart';
import 'package:money_manager/dbfunctions/transaction_db.dart';
import 'package:money_manager/delete_popup.dart';
import 'package:money_manager/home_screen.dart';
import 'package:money_manager/models/category_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/utilities.dart';

// ignore: must_be_immutable
class EditTransactionScreen extends StatefulWidget {
  TransactionModel data;
  int index;
  EditTransactionScreen({Key? key, required this.data, required this.index})
      : super(key: key);

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final notesEditController = TextEditingController();
  final amountEditController = TextEditingController();
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _SelectedCategory;
  String? _categoryID;
  String? selectedValue;

    String counterText = '0';


  @override
  void initState() {
    amountEditController.text = widget.data.amount.toString();
    notesEditController.text = widget.data.notes;
    _selectedDate = widget.data.date;
    _selectedCategoryType = widget.data.type;
    _SelectedCategory = widget.data.categry;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'EDIT YOUR TRANSACTION',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
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
                            Icon(
                              Icons.calendar_today,
                              color: Colors.teal.shade400,
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
                    decoration:  InputDecoration(
                      hintText: 'Amount',
                      counterText: '',
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      suffixText:' ${counterText}/12'
                    ),
                   
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                          isExpanded: true,
                          underline: SizedBox(),
                          hint: Text(
                            Sample.categoryName,
                            style: TextStyle(color: Colors.black87),
                          ),
                          value: _categoryID,
                          items: (_selectedCategoryType == CategoryType.income
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
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: notesEditController,
                    decoration: const InputDecoration(
                      hintText: 'Notes',
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    minLines: 2,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDeletePopup(context, id: widget.data.id);
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(150, 30),
                            primary: expensecolor,
                          ),
                          child: const Text('Delete'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            updateTransaction();
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(150, 30),
                            primary: maincolor,
                          ),
                          child: const Text('Update'),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ));
  }

  updateTransaction() async {
    final amountText = amountEditController.text;
    final notesText = notesEditController.text;
    if (amountText.isEmpty ||
        _selectedDate == null ||
        _SelectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please Fill Fields'),
        backgroundColor: deleteColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 5),
      ));
    } else {
      final parsedAmount = double.tryParse(amountText);
      if (parsedAmount == null) {
        return;
      } else if (parsedAmount == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Enter Correct Amount',
            style: TextStyle(color: Colors.red, fontFamily: ''),
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
            'Updated Successfully',
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
            id: widget.data.id);
        TransactionDB.instance.updateDetails(_transactionModel);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: ((context) => HomeScreen())),
            (route) => false);
      }
    }
  }
}
