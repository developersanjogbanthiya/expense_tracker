import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense_trackee/models/expense_model.dart';

import 'package:expense_trackee/providers/expense_provider.dart';
import 'package:expense_trackee/screens/front_screen.dart';
import 'package:expense_trackee/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  Hive.registerAdapter(ExpenseModelAdapter());
  void scheduleDailyNotification() {
    compute(_scheduleNotification, null);
  }

  // Initialize hive
  await Hive.initFlutter();

  // Open the box
  await Hive.openBox<ExpenseModel>('expenseModel');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
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

void _scheduleNotification(_) {
  NotificationService.showNotification(
      title: "Expense Tracker",
      body: "Don't forget to add your daily expenses",
      scheduled: true,
      interval: Duration(days: 1),
      payload: {
        "navigate": "true",
      },
      actionButtons: [
        NotificationActionButton(
          key: 'Reminder',
          label: 'Add now',
          actionType: ActionType.SilentAction,
          color: Colors.green,
        )
      ]);
}
