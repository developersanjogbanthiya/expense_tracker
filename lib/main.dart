import 'package:expense_trackee/models/expense_model.dart';

import 'package:expense_trackee/providers/expense_provider.dart';
import 'package:expense_trackee/screens/front_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.registerAdapter(ExpenseModelAdapter());

  // Initialize hive
  await Hive.initFlutter();

  // Open the box
  await Hive.openBox<ExpenseModel>('expenseModel');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: FrontScreen(),
      ),
    );
  }
}
