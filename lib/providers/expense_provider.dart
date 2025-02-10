import 'package:expense_trackee/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider() {
    fetchExpenses();
  }
  final List<ExpenseModel> _expensesData = [];
  List<ExpenseModel> get expensesData => _expensesData;

  final List<String> _category = ['Travel', 'Work', 'Leisure', 'Food'];
  List<String> get category => _category;

  String _categorySelected = 'Work';
  String get categorySelected => _categorySelected;

  set categorySelected(String value) {
    _categorySelected = value;
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
