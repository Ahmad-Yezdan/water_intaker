import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/components/alert_dialog.dart';
import 'package:water_intake/models/water_model.dart';
import 'package:water_intake/providers/water_provider.dart';

// ignore: must_be_immutable
class WaterTile extends StatelessWidget {
  WaterTile({
    super.key,
    required this.waterModel,
    required this.context,
  });

  final WaterModel waterModel;
  final BuildContext context;

  var amountController = TextEditingController();

  void updateWater() async {
    Provider.of<WaterProvider>(context, listen: false).update(WaterModel(
        id: waterModel.id,
        amount: double.parse(amountController.text.toString()),
        dateTime: waterModel.dateTime,
        unit: 'ml'));

    if (!context.mounted) {
      return; //the widget is not mounted don't do anything
    }
    amountController.clear();
  }

  void showUpdateWater() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertDialog(
            isAdding: false,
            controller: amountController,
            callback: updateWater);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Row(
          children: [
            const Icon(
              Icons.water_drop,
              size: 20,
              color: Colors.blue,
            ),
            Text(
              '${waterModel.amount.toStringAsFixed(2)} ml',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        subtitle: Text(
            '${waterModel.dateTime.day} / ${waterModel.dateTime.month} / ${waterModel.dateTime.year}  '),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            Provider.of<WaterProvider>(context, listen: false)
                .delete(waterModel);
          },
        ),
        onTap: () {
          showUpdateWater();
        },
      ),
    );
  }
}
