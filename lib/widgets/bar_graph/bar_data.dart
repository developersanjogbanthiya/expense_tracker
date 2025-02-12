import 'package:expense_trackee/widgets/bar_graph/individual_bar.dart';

class BarData {
  final int food;
  final int travel;
  final int work;
  final int leisure;
  final int dailyEssentials;
  final int personalAndLifestyle;
  final int transportation;

  BarData(
      {required this.dailyEssentials,
      required this.personalAndLifestyle,
      required this.transportation,
      required this.leisure,
      required this.food,
      required this.travel,
      required this.work});

  // Declared barData
  List<IndividualBar> barData = [];

  void initializeBarData() {
    // Initialized barData
    barData = [
      IndividualBar(x: 0, y: food),
      IndividualBar(x: 1, y: travel),
      IndividualBar(x: 2, y: work),
      IndividualBar(x: 3, y: leisure),
      IndividualBar(x: 4, y: dailyEssentials),
      IndividualBar(x: 5, y: transportation),
      IndividualBar(x: 6, y: personalAndLifestyle),
    ];
  }
}
