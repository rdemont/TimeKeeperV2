import 'dart:ffi';

import 'package:flutter/material.dart';

class Utils {
  Utils._privateConstructor();

  static final Utils instance = Utils._privateConstructor();

  String longHour(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) {
      return "";
    }

    String result = "";
    result += timeOfDay.hour.toString();
    result += ":" + timeOfDay.minute.toString().padLeft(2, '0');

    return result;
  }

  String NumberFormat(String padding, int length, int number) {
    return number.toString().padLeft(length, padding);
  }

  String longDate(DateTime date) {
    String result = "";
    result += date.day.toString();
    result += "." + date.month.toString();
    result += "." + date.year.toString();

    return result;
  }

  TimeOfDay parseTimeOfDay(String s) {
    if (s.contains("@")) {
      return TimeOfDay(
          hour: int.parse(s.split("@")[0]), minute: int.parse(s.split("@")[1]));
    }
    return TimeOfDay.fromDateTime(DateTime.now());
  }

  String timeOfTheDayToString(TimeOfDay? tod) {
    if (tod == null) {
      return "";
    }
    return "${tod.hour}@${tod.minute}";
  }

  String humainReadableDecimalPerHour(int? minutes) {
    if (minutes == null) {
      return "";
    }
    int hourPerDay = 24;
    int hour = 0;

    int minute = minutes;
    if (minute >= 60) {
      hour = minute ~/ 60;
      minute = minutes - (hour * 60);
    }
    if (minutes + hour == 0) return "";
    return ((hour > 0) ? "$hour" : "0") +
        ".${NumberFormat("0", 2, ((minute / 60) * 100).round())}";
  }

  String humainReadableMinutesPerHour(int? minutes) {
    if (minutes == null) {
      return "";
    }
    int hourPerDay = 24;
    int hour = 0;

    int minute = minutes;
    if (minute >= 60) {
      hour = minute ~/ 60;
      minute = minutes - (hour * 60);
    }
    if (minutes + hour == 0) return "";
    return ((hour > 0) ? "$hour" : "0") + ":${NumberFormat("0", 2, minute)}";
  }

  String humainReadableMinutes(int? minutes) {
    if (minutes == null) {
      return "";
    }
    int hourPerDay = 24;
    int hour = 0;
    int day = 0;
    int minute = minutes;
    if (minute >= 60) {
      hour = minute ~/ 60;
      minute = minutes - (hour * 60);
    }

    if (hour >= hourPerDay) {
      day = hour ~/ hourPerDay;
      hour = minutes - minute - (day * hourPerDay);
    }

    return ((day > 0) ? "$day D / " : "") +
        ((hour > 0) ? "$hour H / " : "") +
        ((minute > 0) ? "$minute M" : "");
  }

  String MonthName(DateTime dt) {
    switch (dt.month) {
      case DateTime.january:
        return "January";
      case DateTime.february:
        return "Febuary";
      case DateTime.march:
        return "March";
      case DateTime.april:
        return "April";
      case DateTime.may:
        return "May";
      case DateTime.june:
        return "June";
      case DateTime.july:
        return "July";
      case DateTime.august:
        return "August";
      case DateTime.september:
        return "September";
      case DateTime.november:
        return "November";
      case DateTime.december:
        return "December";
    }
    return "unknow";
  }

  String dayOftheWeekLong(DateTime dt) {
    switch (dt.weekday) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saterday";
      case DateTime.sunday:
        return "Sunday";
    }
    return "unknow";
  }
}
