import 'package:expense_trackee/providers/expense_provider.dart';
import 'package:expense_trackee/screens/filter_screen.dart';
import 'package:expense_trackee/screens/new_expense.dart';
import 'package:expense_trackee/widgets/each_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FrontScreen extends StatelessWidget {
  const FrontScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    isScrollControlled: true,
                    builder: (builder) {
                      return FilterScreen();
                    });
              },
              icon: Icon(Icons.filter_alt_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (builder) {
                return NewExpense();
              });
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: 32,
        ),
      ),
      body: Consumer<ExpenseProvider>(builder: (context, expense, child) {
        return ListView.builder(
          itemCount: expense.expensesData.length,
          itemBuilder: (contect, index) {
            return EachExpense(expenseData: expense.expensesData[index]);
          },
        );
      }),
    );
  }
}
