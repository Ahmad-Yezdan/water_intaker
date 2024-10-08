class WaterModel {
  final String? id;
  double amount;
  final DateTime dateTime;

  WaterModel(
      {this.id,
      required this.amount,
      required this.dateTime,
      required String unit});

  factory WaterModel.fromJson(Map<String, dynamic> json, String id) {
    return WaterModel(
        id: id,
        amount: json['amount'],
        dateTime: DateTime.parse(json['dateTime']),
        unit: json['unit']);
  }

  // convert WaterModel to JSON, for sending data to firebase
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dateTime': DateTime.now(),
    };
  }

  @override
  String toString() {
    
    return "Id:$id Amount: $amount at Date: ${dateTime.toString()}";
  }
}
