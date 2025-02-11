import 'package:expense_trackee/providers/expense_provider.dart';
import 'package:expense_trackee/widgets/bar_graph/bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatWidget extends StatefulWidget {
  const StatWidget({super.key, required this.activeMonth});

  final int activeMonth;

  @override
  State<StatWidget> createState() => _StatWidgetState();
}

class _StatWidgetState extends State<StatWidget> {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    return Builder(
      builder: (builder) {
        expenseProvider.calculateExp(widget.activeMonth);
        return Consumer<ExpenseProvider>(
          builder: (context, value, child) {
            return Column(
              children: [
                // Text for total expense
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color.fromARGB(155, 60, 164, 0),
                  ),
                  child: Text(
                    'Total Expense - ${expenseProvider.monExp}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                // Chart for all the categories
                Container(
                  height: 300,
                  margin: EdgeInsets.all(12),
                  child: ExpBarGraph(
                    categoryExp: expenseProvider.categoryExp,
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
