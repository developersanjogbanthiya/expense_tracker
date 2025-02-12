import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:expense_trackee/providers/expense_provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);

    Map<String, dynamic> filter = {'dateRange': expenseProvider.datePicked, 'category': expenseProvider.filterCategories};
    void applyChanges() {
      filter['category'].clear();
      if (expenseProvider.food.value) {
        filter['category'].add('Food');
      }
      if (expenseProvider.travel.value) {
        filter['category'].add('Travel');
      }
      if (expenseProvider.leisure.value) {
        filter['category'].add('Leisure');
      }
      if (expenseProvider.work.value) {
        filter['category'].add('Work');
      }
      if (expenseProvider.transportation.value) {
        filter['category'].add('Transportation');
      }
      if (expenseProvider.personalAndLifestyle.value) {
        filter['category'].add('Personal And Lifestyle');
      }
      if (expenseProvider.dailyEssentials.value) {
        filter['category'].add('Daily Essentials');
      }
      expenseProvider.filteredExpenses(filter);
      Navigator.pop(context);
    }

    void clearFilters() {
      expenseProvider.isFilter = false;
      expenseProvider.initialDate = DateTime.now();
      expenseProvider.finalDate = DateTime.now();
      expenseProvider.food.value = false;
      expenseProvider.travel.value = false;
      expenseProvider.leisure.value = false;
      expenseProvider.work.value = false;
      expenseProvider.datePicked = false;
      expenseProvider.transportation.value = false;
      expenseProvider.personalAndLifestyle.value = false;
      expenseProvider.dailyEssentials.value = false;
      filter['category'] = [];
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'Filters',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: clearFilters,
            child: Text('Clear Filters'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
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
                                  expenseProvider.datePicked = true;
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
                            valueListenable: expenseProvider.food,
                            builder: (context, valuee, child) {
                              return Row(
                                children: [
                                  Checkbox(
                                    value: valuee,
                                    onChanged: (value) {
                                      expenseProvider.food.value = value!;
                                    },
                                  ),
                                  Text('Food'),
                                ],
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: expenseProvider.travel,
                            builder: (context, valuee, child) {
                              return Row(
                                children: [
                                  Checkbox(
                                    value: valuee,
                                    onChanged: (value) {
                                      expenseProvider.travel.value = value!;
                                    },
                                  ),
                                  Text('Travel'),
                                ],
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: expenseProvider.work,
                            builder: (context, valuee, child) {
                              return Row(
                                children: [
                                  Checkbox(
                                    value: valuee,
                                    onChanged: (value) {
                                      expenseProvider.work.value = value!;
                                    },
                                  ),
                                  Text('Work'),
                                ],
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: expenseProvider.leisure,
                            builder: (context, valuee, child) {
                              return Row(
                                children: [
                                  Checkbox(
                                    value: valuee,
                                    onChanged: (value) {
                                      expenseProvider.leisure.value = value!;
                                    },
                                  ),
                                  Text('Leisure'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: expenseProvider.transportation,
                            builder: (context, valuee, child) {
                              return Row(
                                children: [
                                  Checkbox(
                                    value: valuee,
                                    onChanged: (value) {
                                      expenseProvider.transportation.value = value!;
                                    },
                                  ),
                                  Text('Transportation'),
                                ],
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: expenseProvider.dailyEssentials,
                            builder: (context, valuee, child) {
                              return Row(
                                children: [
                                  Checkbox(
                                    value: valuee,
                                    onChanged: (value) {
                                      expenseProvider.dailyEssentials.value = value!;
                                    },
                                  ),
                                  Text('Daily Essentials'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: expenseProvider.personalAndLifestyle,
                        builder: (context, valuee, child) {
                          return Row(
                            children: [
                              Checkbox(
                                value: valuee,
                                onChanged: (value) {
                                  expenseProvider.personalAndLifestyle.value = value!;
                                },
                              ),
                              Text('Personal & Lifestyle'),
                            ],
                          );
                        },
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
      ),
    );
  }
}
