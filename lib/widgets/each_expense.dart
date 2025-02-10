import 'package:expense_trackee/models/expense_model.dart';
import 'package:expense_trackee/providers/expense_provider.dart';
import 'package:expense_trackee/screens/edit_expense.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EachExpense extends StatelessWidget {
  const EachExpense({super.key, required this.expenseData});

  final ExpenseModel expenseData;
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    void editExpense() {
      expenseProvider.categorySelected = expenseData.categoryModel;
      showModalBottomSheet(
        context: context,
        builder: (builder) => EditExpense(
          expenseModel: expenseData,
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 8, left: 12, right: 12, top: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 230, 249, 232),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: const Color.fromARGB(255, 200, 199, 199),
            spreadRadius: 0.2,
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Expense title
              Text(
                expenseData.expenseTitle,
                style: TextStyle(
                  overflow: TextOverflow.fade,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              // Expense date

              Text(DateFormat('dd-MMM').format(expenseData.date)),
              Gap(12),
            ],
          ),
          Row(
            children: [
              // Expense
              Text(
                'Rs ${expenseData.expense}',
                style: TextStyle(fontSize: 16),
              ),

              Gap(12),

              // Category
              Text(
                '(${expenseData.categoryModel})',
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              // Spacer
              IconButton(onPressed: editExpense, icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () async {
                    await expenseProvider.deleteExpense(expenseData);
                  },
                  icon: Icon(Icons.delete)),
              // // Edit & Delete Button
            ],
          ),
        ],
      ),
    );
  }
}
