import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:water_intake/bars/bar_data.dart';

class BarGraph extends StatelessWidget {
  final double maxY;
  final double sunWaterAmt;
  final double monWaterAmt;
  final double tueWaterAmt;
  final double wedWaterAmt;
  final double thurWaterAmt;
  final double friWaterAmt;
  final double satWaterAmt;

  const BarGraph(
      {super.key,
      required this.maxY,
      required this.sunWaterAmt,
      required this.monWaterAmt,
      required this.tueWaterAmt,
      required this.wedWaterAmt,
      required this.thurWaterAmt,
      required this.friWaterAmt,
      required this.satWaterAmt});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    //initialize bardata
    BarData barData = BarData(
        sunWaterAmt: sunWaterAmt,
        monWaterAmt: monWaterAmt,
        tueWaterAmt: tueWaterAmt,
        wedWaterAmt: wedWaterAmt,
        thurWaterAmt: thurWaterAmt,
        friWaterAmt: friWaterAmt,
        satWaterAmt: satWaterAmt);

    barData.initBarData();

    return BarChart(BarChartData(
      maxY: maxY,
      minY: 0,
      barGroups: barData.barData
          .map((indvidualBar) => BarChartGroupData(x: indvidualBar.x, barRods: [
                BarChartRodData(
                    toY: indvidualBar.y,
                    color: theme.colorScheme.primary,
                    width: 23,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxY,
                      color: Colors.grey[300],
                    ))
              ]))
          .toList(),
      //styling bar graph
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitlesWidget,
          ))),
    ));
  }

  Widget getBottomTitlesWidget(double value, TitleMeta meta) {
    const TextStyle style = TextStyle(
      color: Color.fromARGB(255, 24, 23, 23),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text(
          "S",
          style: style,
        );
        break;
      case 1:
        text = const Text(
          "M",
          style: style,
        );
        break;
      case 2:
        text = const Text(
          "T",
          style: style,
        );
        break;
      case 3:
        text = const Text(
          "W",
          style: style,
        );
        break;
      case 4:
        text = const Text(
          "T",
          style: style,
        );
        break;
      case 5:
        text = const Text(
          "F",
          style: style,
        );
        break;
      case 6:
        text = const Text(
          "S",
          style: style,
        );
        break;
      default:
        text = const Text("");
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 3,
      child: text,
    );
  }
}
