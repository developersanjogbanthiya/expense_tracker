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

  final List<String> _category = ['Travel', 'Work', 'Leisure', 'Food'];
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

  final expenseBox = Hive.box<ExpenseModel>('expenseModel');

  void fetchExpenses() {
    if (expenseBox.values.isNotEmpty) {
      for (var expense in expenseBox.values) {
        _expensesData.add(expense);
      }
    }
    notifyListeners();
  }

  // Initial date - 1 feb
  // final date - 5 feb
  // expense date - 3 feb

  void filteredExpenses(Map<String, dynamic> filter) {
    if (_datePicked == true || filter['category'].isNotEmpty) {
      _filteredExpensesData.clear();
      // If loop for only category filters
      if (filter['dateRange'] == false && filter['category'].isNotEmpty) {
        print('only category filters');
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
        print('only time range');
        _filteredExpensesData =
            _expensesData.where((expense) => expense.date.isAfter(initialDate) && expense.date.isBefore(finalDate)).toList();
      }

      // If loop for both time range and category filters
      if (_datePicked == true && filter['category'].isNotEmpty) {
        print('both time range and category filters');
        List<ExpenseModel> filteredList =
            _expensesData.where((expense) => expense.date.isAfter(initialDate) && expense.date.isBefore(finalDate)).toList();
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
    }
  }

  Future<void> addNewExpense(ExpenseModel expense) async {
    _expensesData.add(expense);

    notifyListeners();
    await expenseBox.add(expense);
  }

  Future<void> deleteExpense(ExpenseModel expense) async {
    _expensesData.remove(expense);
    notifyListeners();

    await expense.delete();
  }

  void editExpense(ExpenseModel expenseEdited, int index) async {
    _expensesData.removeAt(index);
    _expensesData.insert(index, expenseEdited);
    notifyListeners();

    await expenseEdited.save();
  }
}
