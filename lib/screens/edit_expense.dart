import 'package:expense_trackee/models/expense_model.dart';
import 'package:expense_trackee/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditExpense extends StatefulWidget {
  EditExpense({super.key, required this.expenseModel});
  ExpenseModel expenseModel;

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  DateTime? selectedDate;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<DateTime> date = ValueNotifier<DateTime>(widget.expenseModel.date);

    final TextEditingController titleController = TextEditingController(text: widget.expenseModel.expenseTitle);

    final TextEditingController expenseController = TextEditingController(text: widget.expenseModel.expense.toString());
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    final heightKeyboard = MediaQuery.of(context).viewInsets.bottom;

    void datePicker() async {
      final today = DateTime.now();
      final firstDate = DateTime(today.year - 1, today.month, today.day);

      selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: firstDate, // The oldest date that can be choosed
        lastDate: DateTime.now(),
      );
      date.value = selectedDate!;
    }

    void editExpense() {
      if (formKey.currentState!.validate()) {
        // Add the expense data
        formKey.currentState!.save();
        int index = expenseProvider.expensesData.indexOf(widget.expenseModel);

        widget.expenseModel.expenseTitle = titleController.text;
        widget.expenseModel.expense = int.parse(expenseController.text);
        widget.expenseModel.categoryModel = expenseProvider.categorySelected;
        widget.expenseModel.date = date.value;
        expenseProvider.editExpense(widget.expenseModel, index);

        Navigator.of(context).pop();
        formKey.currentState!.reset();
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 12, right: 12, left: 12, bottom: heightKeyboard),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Expense title
                TextFormField(
                  controller: titleController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: widget.expenseModel.expenseTitle,
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
                          hintText: widget.expenseModel.expense.toString(),
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
                      valueListenable: date,
                      builder: (context, value, child) {
                        return Text(
                          'Date : ${DateFormat('dd-MMM').format(date.value)}',
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
                      onPressed: editExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Save Expense'),
                    ),
                    Gap(12),
                    // Reset Button

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
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
