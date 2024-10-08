import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:water_intake/models/water_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:water_intake/utils/date_helper.dart';

class WaterProvider with ChangeNotifier {
  List<WaterModel> waterDataList = [];

  void addWater(WaterModel water) async {
    final url = Uri.https(
        'water-intaker-4c229-default-rtdb.asia-southeast1.firebasedatabase.app',
        'water.json');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': double.parse(water.amount.toString()),
          'unit': 'ml',
          'dateTime': DateTime.now().toString()
        }));
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      waterDataList.add(WaterModel(
          id: extractedData['name'],
          amount: water.amount,
          dateTime: water.dateTime,
          unit: 'ml'));
    } else {
      print("Error: ${response.statusCode}");
    }
    print(waterDataList);
    notifyListeners();
  }

  Future<List<WaterModel>> getWater() async {
    final url = Uri.https(
        'water-intaker-4c229-default-rtdb.asia-southeast1.firebasedatabase.app',
        'water.json');
    var response = await http.get(url);

    if (response.statusCode == 200 && response.body != 'null') {
      //clear existing data before adding new data
      waterDataList.clear();

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      for (var element in extractedData.entries) {
        waterDataList.add(WaterModel(
            id: element.key,
            amount: element.value['amount'],
            dateTime: DateTime.parse(element.value['dateTime']),
            unit: element.value['unit']));
      }
    }
    notifyListeners();
    return waterDataList;
  }

  void delete(WaterModel waterModel) {
    final url = Uri.https(
        'water-intaker-4c229-default-rtdb.asia-southeast1.firebasedatabase.app',
        'water/${waterModel.id}.json');

    http.delete(
        url); //this can also be saved in response variable and then validated by response status code

    //remove item from list
    waterDataList.removeWhere((element) => element.id == waterModel.id);
    notifyListeners();
  }

  void update(WaterModel water) async {
    final url = Uri.https(
        'water-intaker-4c229-default-rtdb.asia-southeast1.firebasedatabase.app',
        'water/${water.id}.json');

    var response = await http.patch(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': water.amount,
          'unit': 'ml',
          'dateTime': water.dateTime.toString()
        }));

    if (response.statusCode == 200) {
      //update item in list
      waterDataList[
              waterDataList.indexWhere((element) => element.id == water.id)]
          .amount = water.amount;
    } else {
      print("Error: ${response.statusCode}");
    }
    notifyListeners();
  }

  // calculate the weekly water intake
  String calculateWeeklyWaterIntake(WaterProvider value) {
    double weeklySum = 0.0;

    DateTime startOfWeek = getStartOfWeek();

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

    List<double> values = [
      calculateDailyWaterSummary()[sunday] ?? 0,
      calculateDailyWaterSummary()[monday] ?? 0,
      calculateDailyWaterSummary()[tuesday] ?? 0,
      calculateDailyWaterSummary()[wednesday] ?? 0,
      calculateDailyWaterSummary()[thursday] ?? 0,
      calculateDailyWaterSummary()[friday] ?? 0,
      calculateDailyWaterSummary()[saturday] ?? 0,
    ];

    for (var e in values) {
      weeklySum += e;
    }
    return weeklySum.toStringAsFixed(2);
  }

  //calculate daily water intake
  Map<String, double> calculateDailyWaterSummary() {
    Map<String, double> dailyWaterSummary = {};

    //loop though water data list
    for (var water in waterDataList) {
      String date = convertDateTimeToString(water.dateTime);
      double amount = water.amount;

      if (dailyWaterSummary.containsKey(date)) {
        double currentAmount = dailyWaterSummary[date]!;
        currentAmount += amount;
        dailyWaterSummary[date] = currentAmount;
      } else {
        dailyWaterSummary.addAll({date: amount});
      }
    }

    return dailyWaterSummary;
  }
}
