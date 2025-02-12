import 'dart:math';

import 'package:expense_trackee/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider() {
    fetchExpenses();
  }
  final List<ExpenseModel> _expensesData = [];
  List<ExpenseModel> get expensesData => _expensesData;

  List<ExpenseModel> _filteredExpensesData = [];
  List<ExpenseModel> get filteredExpensesData => _filteredExpensesData;

  final List<String> _category = [
    'Travel',
    'Work',
    'Leisure',
    'Food',
    'Daily Essentials',
    'Transportation',
    'Personal & Lifestyle'
  ];
  List<String> get category => _category;

  bool _isFilter = false;

  bool get isFilter => _isFilter;
  set isFilter(bool value) {
    _isFilter = value;
    notifyListeners();
  }

  final List<String> _filterCategories = [];
  List<String> get filterCategories => _filterCategories;

  bool _datePicked = false;
  bool get datePicked => _datePicked;
  set datePicked(bool value) {
    _datePicked = value;
    notifyListeners();
  }

  String _categorySelected = 'Work';
  String get categorySelected => _categorySelected;
  set categorySelected(String value) {
    _categorySelected = value;
    notifyListeners();
  }

  DateTime _initialDate = DateTime.now();
  DateTime get initialDate => _initialDate;
  set initialDate(DateTime date) {
    _initialDate = date;
    notifyListeners();
  }

  DateTime _finalDate = DateTime.now();
  DateTime get finalDate => _finalDate;
  set finalDate(DateTime date) {
    _finalDate = date;
    notifyListeners();
  }

  ValueNotifier<bool> food = ValueNotifier<bool>(false);
  ValueNotifier<bool> travel = ValueNotifier<bool>(false);
  ValueNotifier<bool> leisure = ValueNotifier<bool>(false);
  ValueNotifier<bool> work = ValueNotifier<bool>(false);
  ValueNotifier<bool> dailyEssentials = ValueNotifier<bool>(false);
  ValueNotifier<bool> transportation = ValueNotifier<bool>(false);
  ValueNotifier<bool> personalAndLifestyle = ValueNotifier<bool>(false);

  final expenseBox = Hive.box<ExpenseModel>('expenseModel');

  int _currentMonExp = 0;
  int get currentMonExp => _currentMonExp;
  set currentMonExp(int value) {
    _currentMonExp = value;
    notifyListeners();
  }

  void currentMonthExpense() {
    _currentMonExp = 0;
    DateTime now = DateTime.now();
    DateTime firstDateOfMon = DateTime(now.year, now.month, 1);
    DateTime lastDateOfMon = DateTime(now.year, now.month + 1, 0);

    List<ExpenseModel> currentMonthExpense =
        _expensesData.where((expense) => expense.date.isAfter(firstDateOfMon) && expense.date.isBefore(lastDateOfMon)).toList();

    for (var exp in currentMonthExpense) {
      _currentMonExp += exp.expense;
    }
  }

  void fetchExpenses() {
    if (expenseBox.values.isNotEmpty) {
      for (var expense in expenseBox.values) {
        _expensesData.add(expense);
      }
    }
    currentMonthExpense();
    notifyListeners();
  }

  void filteredExpenses(Map<String, dynamic> filter) {
    if (_datePicked == true || filter['category'].isNotEmpty) {
      _filteredExpensesData.clear();
      // If loop for only category filters
      if (_datePicked == false && filter['category'].isNotEmpty) {
        for (var expense in _expensesData) {
          for (var fil in filter['category']) {
            if (fil == expense.categoryModel) {
              _filteredExpensesData.add(expense);
            }
          }
        }
      }
      // If loop for only time range
      if (_datePicked == true && filter['category'].isEmpty) {
        _filteredExpensesData = _expensesData
            .where((expense) =>
                expense.date.isAfter(initialDate.subtract(Duration(days: 1))) &&
                expense.date.isBefore(finalDate.add(Duration(days: 1))))
            .toList();
      }

      // If loop for both time range and category filters
      if (_datePicked == true && filter['category'].isNotEmpty) {
        List<ExpenseModel> filteredList = _expensesData
            .where((expense) =>
                expense.date.isAfter(initialDate.subtract(Duration(days: 1))) &&
                expense.date.isBefore(finalDate.add(Duration(days: 1))))
            .toList();
        for (var expense in filteredList) {
          for (var fil in filter['category']) {
            if (fil == expense.categoryModel) {
              _filteredExpensesData.add(expense);
            }
          }
        }
      }

      isFilter = true;
      notifyListeners();
    } else {
      isFilter = false;
    }
  }

  Future<void> addNewExpense(ExpenseModel expense) async {
    _expensesData.add(expense);
    currentMonthExpense();

    notifyListeners();
    await expenseBox.add(expense);
  }

  Future<void> deleteExpense(ExpenseModel expense) async {
    _expensesData.remove(expense);
    currentMonthExpense();
    notifyListeners();

    await expense.delete();
  }

  void editExpense(ExpenseModel expenseEdited, int index) async {
    _expensesData.removeAt(index);
    _expensesData.insert(index, expenseEdited);
    currentMonthExpense();
    notifyListeners();

    await expenseEdited.save();
  }

  int _monExp = 0;
  int get monExp => _monExp;
  set monExp(int value) {
    _monExp = value;
    notifyListeners();
  }

  final Map<String, int> _categoryExp = {
    "Food": 0,
    "Travel": 0,
    "Work": 0,
    "Leisure": 0,
    "Transportation": 0,
    "Personal And Lifestyle": 0,
    "Daily Essentials": 0
  };
  Map<String, int> get categoryExp => _categoryExp;

  int _foodExp = 0;
  int get foodExp => _foodExp;
  set foodExp(int value) {
    _foodExp = value;
    notifyListeners();
  }

  int _travelExp = 0;
  int get travelExp => _travelExp;
  set travelExp(int value) {
    _travelExp = value;
    notifyListeners();
  }

  int _workExp = 0;
  int get workExp => _workExp;
  set workExp(int value) {
    _workExp = value;
    notifyListeners();
  }

  int _leisureExp = 0;
  int get leisureExp => _leisureExp;
  set leisureExp(int value) {
    _leisureExp = value;
    notifyListeners();
  }

  int _transExp = 0;
  int get transExp => _transExp;
  set transExp(int value) {
    _transExp = value;
    notifyListeners();
  }

  int _perAndLifeExp = 0;
  int get perAndLifeExp => _perAndLifeExp;
  set perAndLifeExp(int value) {
    _perAndLifeExp = value;
    notifyListeners();
  }

  int _dailyExp = 0;
  int get dailyExp => _dailyExp;
  set dailyExp(int value) {
    _dailyExp = value;
    notifyListeners();
  }

  void calculateExp(int currMonth) {
    // Resetting all the values to 0
    _monExp = 0;
    _foodExp = 0;
    _travelExp = 0;
    _workExp = 0;
    _leisureExp = 0;
    _dailyExp = 0;
    _perAndLifeExp = 0;
    _transExp = 0;

    DateTime now = DateTime.now();
    DateTime firstDateOfMon = DateTime(now.year, now.month - currMonth, 1);
    DateTime lastDateOfMon = DateTime(now.year, now.month + 1 - currMonth, 0);

    List<ExpenseModel> currentMonthExpense =
        _expensesData.where((expense) => expense.date.isAfter(firstDateOfMon) && expense.date.isBefore(lastDateOfMon)).toList();

    for (var exp in currentMonthExpense) {
      _monExp += exp.expense;
    }

    for (var eachExpense in currentMonthExpense) {
      if (eachExpense.categoryModel == 'Food') {
        _foodExp += eachExpense.expense;
      }
      if (eachExpense.categoryModel == 'Travel') {
        _travelExp += eachExpense.expense;
      }
      if (eachExpense.categoryModel == 'Work') {
        _workExp += eachExpense.expense;
      }
      if (eachExpense.categoryModel == 'Leisure') {
        _leisureExp += eachExpense.expense;
      }
      if (eachExpense.categoryModel == 'Daily Essentials') {
        _dailyExp += eachExpense.expense;
      }
      if (eachExpense.categoryModel == 'Personal And Lifestyle') {
        _perAndLifeExp += eachExpense.expense;
      }
      if (eachExpense.categoryModel == 'Transportation') {
        _transExp += eachExpense.expense;
      }
    }
    _categoryExp['Food'] = _foodExp;
    _categoryExp['Travel'] = _travelExp;
    _categoryExp['Work'] = _workExp;
    _categoryExp['Leisure'] = _leisureExp;
    _categoryExp['Transportation'] = _transExp;
    _categoryExp['Personal And Lifestyle'] = _perAndLifeExp;
    _categoryExp['Daily Essentials'] = _dailyExp;
  }
}
