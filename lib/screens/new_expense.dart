import 'package:expense_trackee/models/expense_model.dart';
import 'package:expense_trackee/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController expenseController = TextEditingController();

  final ValueNotifier<DateTime> _date = ValueNotifier<DateTime>(DateTime.now());

  DateTime? selectedDate;

  void datePicker() async {
    final today = DateTime.now();
    final firstDate = DateTime(today.year - 1, today.month, today.day);

    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate, // The oldest date that can be choosed
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      _date.value = selectedDate!;
    }
  }

  void addExpense(ExpenseProvider expenseProvider) {
    if (_formKey.currentState!.validate()) {
      // Add the expense data
      _formKey.currentState!.save();

      ExpenseModel expenseData = ExpenseModel()
        ..expenseTitle = titleController.text
        ..expense = int.parse(expenseController.text)
        ..date = _date.value
        ..categoryModel = expenseProvider.categorySelected;

      expenseProvider.addNewExpense(expenseData);

      Navigator.of(context).pop();
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    final heightKeyboard = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 12, right: 12, left: 12, bottom: heightKeyboard),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Expense title
                TextFormField(
                  controller: titleController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: 'Expense Title',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 2) {
                      return 'Enter appropriate title';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    titleController.text = newValue!;
                  },
                ),
                Row(
                  children: [
                    // Expense in Rs.
                    Expanded(
                      child: TextFormField(
                        controller: expenseController,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: 'Rs.',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || int.tryParse(value) == null || int.parse(value) == 0) {
                            return 'Enter appropriate data';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          expenseController.text = newValue!;
                        },
                      ),
                    ),
                    Gap(32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category:'),
                        Gap(4),
                        Container(
                          // width: 72,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Consumer<ExpenseProvider>(
                            builder: (context, expenseProvider, child) {
                              return DropdownButton<String>(
                                borderRadius: BorderRadius.circular(12),
                                padding: EdgeInsets.only(left: 16, right: 16),
                                dropdownColor: const Color.fromARGB(255, 237, 251, 238),
                                value: expenseProvider.categorySelected,
                                iconSize: 0,
                                elevation: 8,
                                underline: const SizedBox.shrink(),
                                items: expenseProvider.category.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  expenseProvider.categorySelected = value!;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _date,
                      builder: (context, value, child) {
                        return Text(
                          'Date : ${DateFormat('dd-MMM').format(_date.value)}',
                          style: TextStyle(fontSize: 16),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: datePicker,
                      icon: const Icon(Icons.calendar_month),
                    )
                  ],
                ),
                Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        addExpense(expenseProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Add Expense'),
                    ),
                    Gap(12),
                    // Reset Button

                    TextButton(
                      onPressed: () {
                        _date.value = DateTime.now();
                        _formKey.currentState!.reset();
                      },
                      child: Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
