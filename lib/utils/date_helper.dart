//get weekDay from a dateTime object
String getWeekDay(DateTime dateTime) {
  switch (dateTime.weekday) {
    case 1:
      return 'Mon';
    case 2:
      return 'Tue';
    case 3:
      return 'Wed';
    case 4:
      return 'Thur';
    case 5:
      return 'Fri';
    case 6:
      return 'Sat';
    case 7:
      return 'Sun';
    default:
      return '';
  }
}

DateTime getStartOfWeek() {
  DateTime? starOfWeek;

  //get the current data
  DateTime dateTime = DateTime.now();

  for (int i = 0; i < 7; i++) {
    if (getWeekDay(dateTime.subtract(Duration(days: i))) == 'Sun') {
      starOfWeek = dateTime.subtract(Duration(days: i));
    }
  }
  return starOfWeek!;
}

String convertDateTimeToString(DateTime dateTime) {
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();

  if (month.length == 1) {
    month = '0$month';
  }
  if (day.length == 1) {
    day = '0$day';
  }

  return year + month + day;
}
