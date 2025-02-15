import 'package:expense_trackee/widgets/stat_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class StatScreen extends StatelessWidget {
  StatScreen({super.key});

  final DateTime now = DateTime.now();
  final ValueNotifier<int> activeMonth = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Statistics',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        centerTitle: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: activeMonth,
        builder: (context, value, child) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Current Month
                  ElevatedButton(
                    onPressed: () {
                      activeMonth.value = 0;
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: activeMonth.value == 0 ? Colors.white : Colors.black,
                        backgroundColor: activeMonth.value == 0 ? Colors.green : Theme.of(context).canvasColor),
                    child: Text(
                      DateFormat('MMM').format(
                        DateTime(now.year, now.month),
                      ),
                    ),
                  ),
                  // Last Month
                  ElevatedButton(
                    onPressed: () {
                      activeMonth.value = 1;
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: activeMonth.value == 1 ? Colors.white : Colors.black,
                        backgroundColor: activeMonth.value == 1 ? Colors.green : Theme.of(context).canvasColor),
                    child: Text(
                      DateFormat('MMM').format(
                        DateTime(now.year, now.month - 1),
                      ),
                    ),
                  ),
                  // Last to last month
                  ElevatedButton(
                    onPressed: () {
                      activeMonth.value = 2;
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: activeMonth.value == 2 ? Colors.white : Colors.black,
                        backgroundColor: activeMonth.value == 2 ? Colors.green : Theme.of(context).canvasColor),
                    child: Text(
                      DateFormat('MMM').format(
                        DateTime(now.year, now.month - 2),
                      ),
                    ),
                  ),
                ],
              ),

              Gap(32),
              // Chart Widget for the selected month
              StatWidget(activeMonth: activeMonth.value),
            ],
          );
        },
      ),
    );
  }
}
