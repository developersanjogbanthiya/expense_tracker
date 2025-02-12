import 'package:expense_trackee/widgets/bar_graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpBarGraph extends StatelessWidget {
  const ExpBarGraph({super.key, required this.categoryExp});
  final Map<String, int> categoryExp;

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      leisure: categoryExp['Leisure']!,
      food: categoryExp['Food']!,
      travel: categoryExp['Travel']!,
      work: categoryExp['Work']!,
      transportation: categoryExp['Transportation']!,
      personalAndLifestyle: categoryExp['Personal And Lifestyle']!,
      dailyEssentials: categoryExp['Daily Essentials']!,
    );

    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        minY: 0,
        //  maxY: 10000,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: double.parse(
                      data.y.toString(),
                    ),
                    color: const Color.fromARGB(255, 94, 169, 96),
                    width: 12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.bold,
    fontSize: 10,
  );

  Widget text;
  switch (value) {
    case 0:
      text = Text(
        'F',
        style: style,
      );
      break;
    case 1:
      text = Text(
        'T',
        style: style,
      );
      break;
    case 2:
      text = Text(
        'W',
        style: style,
      );
      break;
    case 3:
      text = Text(
        'L',
        style: style,
      );
      break;
    case 4:
      text = Text(
        'DE',
        style: style,
      );
      break;
    case 5:
      text = Text(
        'Fuel',
        style: style,
      );
      break;
    case 6:
      text = Text(
        'P & L',
        style: style,
      );
      break;
    default:
      text = Text(
        '',
        style: style,
      );
  }
  return SideTitleWidget(meta: meta, child: text);
}
