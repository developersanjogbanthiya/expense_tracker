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
    if (filter['dateRange'] == true || filter['category'].isNotEmpty) {
      if (filter['dateRange'] == true) {
        _filteredExpensesData =
            _expensesData.where((expense) => expense.date.isAfter(initialDate) && expense.date.isBefore(finalDate)).toList();
      }

      if (filter['category'].isNotEmpty) {
        if (filter['category'].contains('Food')) {
          _filteredExpensesData = _filteredExpensesData.where((expense) => expense.categoryModel == 'Food').toList();
        }
        if (filter['category'].contains('Travel')) {
          _filteredExpensesData = _filteredExpensesData.where((expense) => expense.categoryModel == 'Travel').toList();
        }
        if (filter['category'].contains('Work')) {
          _filteredExpensesData = _filteredExpensesData.where((expense) => expense.categoryModel == 'Work').toList();
        }
        if (filter['category'].contains('Leisure')) {
          _filteredExpensesData = _filteredExpensesData.where((expense) => expense.categoryModel == 'Leisure').toList();
        }
      }
    }
    isFilter = true;
    notifyListeners();
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
