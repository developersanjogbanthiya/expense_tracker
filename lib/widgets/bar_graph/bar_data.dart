import 'package:expense_trackee/widgets/bar_graph/individual_bar.dart';

class BarData {
  final int food;
  final int travel;
  final int work;
  final int leisure;

  BarData({required this.leisure, required this.food, required this.travel, required this.work});

  // Declared barData
  List<IndividualBar> barData = [];

  void initializeBarData() {
    // Initialized barData
    barData = [
      IndividualBar(x: 0, y: food),
      IndividualBar(x: 1, y: travel),
      IndividualBar(x: 2, y: work),
      IndividualBar(x: 3, y: leisure),
    ];
  }
}
