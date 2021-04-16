import 'package:intl/intl.dart';

class DateHelper {
  static String getDateAsTurkish([String dateString, int addDayCount]) {
    if (dateString == null) {
      var formatter = new DateFormat('dd/MM/y');
      if (addDayCount == null || addDayCount == 0)
        return formatter.format(DateTime.now());

      var date = DateTime.now().add(new Duration(days: addDayCount));
      return formatter.format(date);
    } else {
      var date = DateTime.parse(dateString);
      if (addDayCount == null) addDayCount = 0;
      date = date.add(new Duration(days: addDayCount));
      var formatter = new DateFormat('dd/MM/y');
      return formatter.format(date);
    }
  }

  static String currentDate(String format) {
    var now = new DateTime.now();
    var formatter = new DateFormat(format);
    return formatter.format(now);
  }

  static String currentDateAsTurkish() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/y');
    return formatter.format(now);
  }

  static DateTime convertStringToDate(String dateString,
      {dateFormat = 'dd.MM.yyyy hh:mm'}) {
    return new DateFormat(dateFormat).parse(dateString);
  }

  static String getDateTimeAsTurkish(String dateString) {
    if(dateString==null || dateString.isEmpty)return "";
    var date = DateTime.parse(dateString);
    var formatter = new DateFormat('dd/MM/y hh:mm');
    return formatter.format(date);
  }
}
