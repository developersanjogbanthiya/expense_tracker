import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:expense_trackee/providers/expense_provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatelessWidget {
  FilterScreen({super.key});

  ValueNotifier<bool> food = ValueNotifier<bool>(false);
  ValueNotifier<bool> travel = ValueNotifier<bool>(false);
  ValueNotifier<bool> leisure = ValueNotifier<bool>(false);
  ValueNotifier<bool> work = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);

    Map<String, dynamic> filter = {'dateRange': false, 'category': []};
    void applyChanges() {
      if (food.value) {
        filter['category'].add('Food');
      }
      if (travel.value) {
        filter['category'].add('Travel');
      }
      if (leisure.value) {
        filter['category'].add('Leisure');
      }
      if (work.value) {
        filter['category'].add('Work');
      }
      expenseProvider.filteredExpenses(filter);
    }

    void clearFilters() {
      expenseProvider.initialDate = DateTime.now();
      expenseProvider.finalDate = DateTime.now();
      food.value = false;
      travel.value = false;
      leisure.value = false;
      work.value = false;
      filter['dateRange'] = false;
      filter['category'] = [];
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'Filters',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [TextButton(onPressed: clearFilters, child: Text('Clear Filters'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Months

                    Text(
                      'Date Range',
                      style: TextStyle(fontSize: 16),
                    ),
                    Gap(12),
                    Consumer<ExpenseProvider>(
                      builder: (context, value, child) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () async {
                            List<DateTime?>? result = await showCalendarDatePicker2Dialog(
                                context: context,
                                config: CalendarDatePicker2WithActionButtonsConfig(
                                  calendarType: CalendarDatePicker2Type.range,
                                ),
                                dialogSize: const Size(360, 360));
                            if (result != null) {
                              value.initialDate = result[0]!;
                              value.finalDate = result[1]!;
                              DateTime date = DateTime.now();
                              if (DateTime(value.initialDate.year, value.initialDate.month, value.initialDate.day) !=
                                  DateTime(date.year, date.month, date.day)) {
                                filter['dateRange'] = true;
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Icon(FluentIcons.calendar_16_regular, color: Colors.white),
                              const Gap(8),
                              Text(
                                  '${DateFormat('dd MMM yy').format(value.initialDate)} - ${DateFormat('dd MMM yy').format(value.finalDate)}'),
                            ],
                          ),
                        );
                      },
                    ),

                    Gap(16),
                    // Categories
                    Text(
                      'Categories',
                      style: TextStyle(fontSize: 16),
                    ),

                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: food,
                          builder: (context, valuee, child) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: valuee,
                                  onChanged: (value) {
                                    food.value = value!;
                                  },
                                ),
                                Text('Food'),
                              ],
                            );
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: travel,
                          builder: (context, valuee, child) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: valuee,
                                  onChanged: (value) {
                                    travel.value = value!;
                                  },
                                ),
                                Text('Travel'),
                              ],
                            );
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: work,
                          builder: (context, valuee, child) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: valuee,
                                  onChanged: (value) {
                                    work.value = value!;
                                  },
                                ),
                                Text('Work'),
                              ],
                            );
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: leisure,
                          builder: (context, valuee, child) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: valuee,
                                  onChanged: (value) {
                                    leisure.value = value!;
                                  },
                                ),
                                Text('Leisure'),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            // Apply button
            ElevatedButton(
              onPressed: applyChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Apply Changes'),
            ),
            Gap(12),
          ],
        ),
      ),
    );
  }
}
