import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/providers/water_provider.dart';
import 'package:water_intake/utils/date_helper.dart';

class WaterSummary extends StatelessWidget {
  final DateTime startOfWeek;

  const WaterSummary({super.key, required this.startOfWeek});

  double calculateMaxAmount(
    WaterProvider waterProvider,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double? maxAmount = 100;
    List<double> values = [
      waterProvider.calculateDailyWaterSummary()[sunday] ?? 0,
      waterProvider.calculateDailyWaterSummary()[monday] ?? 0,
      waterProvider.calculateDailyWaterSummary()[tuesday] ?? 0,
      waterProvider.calculateDailyWaterSummary()[wednesday] ?? 0,
      waterProvider.calculateDailyWaterSummary()[thursday] ?? 0,
      waterProvider.calculateDailyWaterSummary()[friday] ?? 0,
      waterProvider.calculateDailyWaterSummary()[saturday] ?? 0,
    ];

    //sort from smallest to largest
    values.sort();

    //get largest value
    //incraese max amount by x% of the largest value
    maxAmount = values.last * 1.3;
    return maxAmount == 0 ? 100 : maxAmount;
  }

  @override
  Widget build(BuildContext context) {
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<WaterProvider>(
      builder: (context, value, child) {
        return SizedBox(
          height: 200,
          child: BarGraph(
              maxY: calculateMaxAmount(value, sunday, monday, tuesday,
                  wednesday, thursday, friday, saturday),
              sunWaterAmt: value.calculateDailyWaterSummary()[sunday] ?? 0,
              monWaterAmt: value.calculateDailyWaterSummary()[monday] ?? 0,
              tueWaterAmt: value.calculateDailyWaterSummary()[tuesday] ?? 0,
              wedWaterAmt: value.calculateDailyWaterSummary()[wednesday] ?? 0,
              thurWaterAmt: value.calculateDailyWaterSummary()[thursday] ?? 0,
              friWaterAmt: value.calculateDailyWaterSummary()[friday] ?? 0,
              satWaterAmt: value.calculateDailyWaterSummary()[saturday] ?? 0),
        );
      },
    );
  }
}
