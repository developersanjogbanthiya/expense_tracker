import 'package:expense_trackee/providers/expense_provider.dart';
import 'package:expense_trackee/screens/filter_screen.dart';
import 'package:expense_trackee/screens/new_expense.dart';
import 'package:expense_trackee/screens/stat_screen.dart';
import 'package:expense_trackee/widgets/each_expense.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FrontScreen extends StatelessWidget {
  const FrontScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        centerTitle: false,
        actions: [
          // Stat Screen
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (builder) => StatScreen(),
                ),
              );
            },
            icon: Icon(FluentIcons.chart_multiple_16_filled),
          ),
          // Filter Screen
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                enableDrag: true,
                isScrollControlled: false,
                builder: (builder) {
                  return FilterScreen();
                },
              );
            },
            icon: Consumer<ExpenseProvider>(
              builder: (context, value, child) {
                if (!expenseProvider.isFilter) {
                  return Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.black,
                  );
                }
                return Icon(
                  Icons.filter_alt,
                  color: Colors.green,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
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
        if (expense.isFilter == false) {
          String currentMonth = DateFormat('MMM').format(DateTime(DateTime.now().year, DateTime.now().month));
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (builder) => StatScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color.fromARGB(255, 67, 81, 59),
                  ),
                  child: Text(
                    '$currentMonth Total Expense: Rs.${expense.currentMonExp}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: expense.expensesData.length,
                  itemBuilder: (contect, index) {
                    return EachExpense(expenseData: expense.expensesData[index]);
                  },
                ),
              )
            ],
          );
        } else {
          return ListView.builder(
            itemCount: expense.filteredExpensesData.length,
            itemBuilder: (contect, index) {
              return EachExpense(expenseData: expense.filteredExpensesData[index]);
            },
          );
        }
      }),
    );
  }
}
