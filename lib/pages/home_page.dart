import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/components/alert_dialog.dart';
import 'package:water_intake/components/water_intake_summary.dart';
import 'package:water_intake/components/water_tile.dart';
import 'package:water_intake/models/water_model.dart';
import 'package:water_intake/providers/water_provider.dart';
import 'package:water_intake/utils/date_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController();
  bool _isLoading = true;

  void saveWater() async {
    Provider.of<WaterProvider>(context, listen: false).addWater(WaterModel(
        amount: double.parse(amountController.text.toString()),
        dateTime: DateTime.now(),
        unit: 'ml'));

    if (!context.mounted) {
      return; //the widget is not mounted don't do anything
    }
    amountController.clear();
  }

  void addWater() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertDialog(
            isAdding: true, controller: amountController, callback: saveWater);
      },
    );
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    await Provider.of<WaterProvider>(context, listen: false)
        .getWater()
        .then((waterList) => {
              setState(() {
                _isLoading = false;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Consumer<WaterProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            // title: const Text("Water"),

            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Weekly: ",
                  style: theme.textTheme.titleLarge,
                ),
                Text("${value.calculateWeeklyWaterIntake(value)} ml",
                    style: theme.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            centerTitle: true,
            // elevation: 4,
            // actions: [
            //   IconButton(onPressed: () {}, icon: const Icon(Icons.map))
            // ],
          ),
          body: !_isLoading
              ? value.waterDataList.isEmpty
                  ? const Center(
                      child: Text(
                          "No water intake found. Click add button to add some."),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          WaterSummary(
                            startOfWeek: getStartOfWeek(),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.waterDataList.length,
                            itemBuilder: (context, index) {
                              final waterModel = value.waterDataList[index];

                              return WaterTile(context: context,waterModel: waterModel);
                            },
                          ),
                        ],
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: addWater,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
