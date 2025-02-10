import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  late String expenseTitle;

  @HiveField(1)
  late int expense;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late String categoryModel;
}
