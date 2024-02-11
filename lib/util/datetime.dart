import 'package:intl/intl.dart';

class DateTimeManager {

  static const String dateTimeFormat24 = "yyyy-MM-dd HH:mm:ss";
  static const String dateTimeFormat24_2 = "yyyy-MM-ddTHH:mm:ssZ";
  static const String dateTimeFormat = "yyyy-MM-dd hh:mm aa"; // main keep format
  static const String dateTimeFormat24_3 = "MM-dd-yyyy HH:mm:ss";

  // static const dateFormat="yyyy-MM-dd";

  static const dateFormat = "MM-dd-yyyy";

  static const dateFormat2 = "dd/MM/yyyy";
  static const dateFormat3 = "MMM dd, yyyy";
  static const dateFormat4 = "MMM dd";

  static const timeFormat = "hh:mm aa";

  static const timeFormat1 = "HH:mm:ss";
  static const timeFormat2 = "mm:ss";
  static const timeFormat3 = "hh:mm";
  static const timeFormat4 = "hh";

  static const TOD_AM = "AM",
      TOD_PM = "PM";


  static DateTime parseDateTime24(String date,
      {String format = dateTimeFormat24, bool isutc = false,}) {
    DateTime dateTime = DateFormat(format).parse(date, isutc,);
    return isutc ? dateTime.toLocal() : dateTime;
  }

  static String getFormattedDateTime(String date, {bool isutc = false,
    String format = dateTimeFormat, String format2 = dateTimeFormat24}) {
    return DateFormat(format).format(
        parseDateTime24(date, isutc: isutc, format: format2));
  }

  static String getFormattedDateTimeFromDateTime(DateTime date,
      {String format = dateTimeFormat,
        bool isutc = false}) {
    return DateFormat(format).format(isutc ? date.toLocal() : date,);
  }

  static DateTime getCurrentDate({bool isutc = false}) {
    var now = DateTime.now();
    return !isutc ? now : now.toUtc();
  }

/*  static String getFormattedTimeFromDateTime(DateTime date){
    return "${_getUnit(date.hour)}:${_getUnit(date.minute)}:${_getUnit(date.second)}";
  }*/

  static int getDuration(String dur) {
    int secs = 0;
    List<String> list = dur.split(":");
    try {
      secs += int.parse(list[0]) * 3600;
      secs += int.parse(list[1]) * 60;
    }
    catch (ex) {

    }
    //secs+=int.parse(list[0]);
    return secs;
  }

  static String getElapsedTime(int seconds, {String format = timeFormat2}) {
    int hours = 0,
        mins = 0,
        secs = 0;
    double hh = seconds / 3600;
    if (hh >= 1) {
      hours = hh.toInt();
      seconds = seconds - (3600 * hours);
      double mm = seconds / 60;
      if (mm >= 1) {
        mins = mm.toInt();
        secs = seconds - (60 * mins);
      }
      else {
        secs = seconds;
      }
    }
    else {
      double mm = seconds / 60;
      if (mm >= 1) {
        mins = mm.toInt();
        secs = seconds - (60 * mins);
      }
      else {
        secs = seconds;
      }
    }
    var list = format.split(":");
    String val = "";
    list.forEach((value) {
      if (value == "hh") {
        val += "${_getUnit(hours)}:";
      }
      else if (value == "mm") {
        val += "${_getUnit(mins)}:";
      }
      else if (value == "ss") {
        val += "${_getUnit(secs)}:";
      }
    });
    //val = val.removeCharAt(val.length - 1);
    return val;
  }

  static String formatTime12(String time24) {
    List<String> vals = time24.split(":");
    int hour = int.parse(vals[0]);
    int min = int.parse(vals[1]);
    String tod = TOD_AM;
    if (hour <= 0) {
      hour = 12;
    }
    else if (hour == 12) {
      tod = TOD_PM;
    }
    else if (hour > 12) {
      hour = hour - 12;
      tod = TOD_PM;
    }
    return "${_getUnit(hour)}:${_getUnit(min)} ${tod}";
  }

  static String formatTime24(String time12, {bool secs = false}) {
    final List<int> vals = _extractTimeTo24(time12);
    return "${_getUnit(vals[0])}:${_getUnit(vals[1])}${secs ? ":00" : ""}";
  }

  static List<int> _extractTimeTo24(String time) {
    List<String> list = time.split(" ");
    List<String> vals = list[0].split(":");
    String tod = list[1];
    int hour = int.parse(vals[0]);
    int min = int.parse(vals[1]);
    if (tod == TOD_PM && hour < 12) {
      hour = hour + 12;
    }
    else if (tod == TOD_AM && hour == 12) {
      hour = 0;
    }
    return [hour, min];
  }

  static int dateDifference(DateTime date1, DateTime date2) {
    //assert(date1.isAfter(date2) || date1.isAtSameMomentAs(date2));
    int milli = date2.millisecondsSinceEpoch - date1.millisecondsSinceEpoch;
    return milli ~/ 1000;
  }

  static int timeDifference12(String time12, String time212) {
    return timeDifference24(formatTime24(time12), formatTime24(time212));
  }

  static int timeDifference24(String time24, String time224) {
    //assert(date1.isAfter(date2) || date1.isAtSameMomentAs(date2));
    int secs1 = getDuration(time24);
    int secs2 = getDuration(time224);
    int secs = secs2 - secs1;
    print("secs: $secs");
    return secs;
  }

  static String _getUnit(int m) {
    return "${m <= 9 ? "0" : ""}${m}";
  }

  static String getTimeAgo(String date,{DateTime? from}){
    var now=from??getCurrentDate();
    var dateTime= parseDateTime24(date,format: dateTimeFormat);
    //int secs=
    int milli=now.millisecondsSinceEpoch-dateTime.millisecondsSinceEpoch;
    int secs=milli~/1000;

    String unit="s";
    if(secs>=60){
      secs=secs~/60;//mins
      unit="m";
      if(secs>=60){
        secs=secs~/60;//hours
        unit="h";
        if(secs>=24){
          secs=secs~/24;//days
          unit="d";
          if(secs>=30){
            secs=secs~/30;
            unit="m";
            if(secs>=12){
              secs=secs~/12;
              unit="y";
            }
          }
        }
      }
    }
    // unit=secs<=1?unit.substring(0,unit.length-1):unit;
    return "$secs$unit";
  }
}