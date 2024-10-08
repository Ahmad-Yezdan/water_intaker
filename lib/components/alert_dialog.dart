import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final bool isAdding;
  final TextEditingController controller;
  final VoidCallback callback;
  const MyAlertDialog(
      {super.key,
      required this.isAdding,
      required this.controller,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isAdding ? "Add Water" : "Update Water"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isAdding
              ? "Add water to your daily intake"
              : "Update water from your daily intake"),
          const SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Amount",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            controller: controller,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              callback();
              Navigator.pop(context);
            },
            child: Text(isAdding ? "Save" : "Update")),
      ],
    );
  }
}
