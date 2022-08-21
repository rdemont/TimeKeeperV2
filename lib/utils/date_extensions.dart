import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension DateWeekExtensions on DateTime {
  /// The ISO 8601 week of year [1..53].
  ///
  /// Algorithm from https://en.wikipedia.org/wiki/ISO_week_date#Algorithms
  int get weekOfYear {
    // Add 3 to always compare with January 4th, which is always in week 1
    // Add 7 to index weeks starting with 1 instead of 0
    final woy = ((ordinalDate - weekday + 10) ~/ 7);

    // If the week number equals zero, it means that the given date belongs to the preceding (week-based) year.
    if (woy == 0) {
      // The 28th of December is always in the last week of the year
      return DateTime(year - 1, 12, 28).weekOfYear;
    }

    // If the week number equals 53, one must check that the date is not actually in week 1 of the following year
    if (woy == 53 &&
        DateTime(year, 1, 1).weekday != DateTime.thursday &&
        DateTime(year, 12, 31).weekday != DateTime.thursday) {
      return 1;
    }

    return woy;
  }

  /// The ordinal date, the number of days since December 31st the previous year.
  ///
  /// January 1st has the ordinal date 1
  ///
  /// December 31st has the ordinal date 365, or 366 in leap years
  int get ordinalDate {
    const offsets = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    return offsets[month - 1] + day + (isLeapYear && month > 2 ? 1 : 0);
  }

  /// True if this date is on a leap year.
  bool get isLeapYear {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  DateTime get firstDayOfTheMonth {
    return DateTime(year, month, 1);
  }

  DateTime get lastDayOfTheMonth {
    return DateTime(year, month + 1, 0);
  }

  DateTime get firstDayOfTheMonthView {
    DateTime dtStart = firstDayOfTheMonth;
    while (dtStart.weekday != DateTime.monday) {
      dtStart = dtStart.add(Duration(days: -1));
    }
    return dtStart;
  }

  DateTime get lastDayOfTheMonthView {
    DateTime dtEnd = lastDayOfTheMonth;
    while (dtEnd.weekday != DateTime.sunday) {
      dtEnd = dtEnd.add(Duration(days: 1));
    }
    return dtEnd;
  }

  DateTime get firstDayOfTheWeek {
    return subtract(Duration(days: weekday - 1));
  }

  DateTime get lastDayOfTheWeek {
    return add(Duration(days: DateTime.daysPerWeek - weekday));
  }

  String formated(String format) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(this);
  }

  bool isSameDateAs(DateTime? date) {
    return year == date?.year && month == date?.month && day == date?.day;
  }

  int get dateTimeItNotation {
    return int.parse(formated("yyyyMMddHHmm"));
  }

  int get dateItNotation {
    return int.parse(formated("yyyyMMdd"));
  }

  TimeOfDay get timeOfDay {
    return TimeOfDay(hour: hour, minute: minute);
  }

  String MonthNameShort(BuildContext context) {
    switch (month) {
      case 1:
        return AppLocalizations.of(context)!.january_short;
      case 2:
        return AppLocalizations.of(context)!.february_short;
      case 3:
        return AppLocalizations.of(context)!.march_short;
      case 4:
        return AppLocalizations.of(context)!.april_short;
      case 5:
        return AppLocalizations.of(context)!.may_short;
      case 6:
        return AppLocalizations.of(context)!.june_short;
      case 7:
        return AppLocalizations.of(context)!.july_short;
      case 8:
        return AppLocalizations.of(context)!.august_short;
      case 9:
        return AppLocalizations.of(context)!.september_short;
      case 10:
        return AppLocalizations.of(context)!.october_short;
      case 11:
        return AppLocalizations.of(context)!.november_short;
      case 12:
        return AppLocalizations.of(context)!.december_short;
    }
    return "NDEF";
  }

  String MonthName(BuildContext context) {
    switch (month) {
      case 1:
        return AppLocalizations.of(context)!.january_long;
      case 2:
        return AppLocalizations.of(context)!.february_long;
      case 3:
        return AppLocalizations.of(context)!.march_long;
      case 4:
        return AppLocalizations.of(context)!.april_long;
      case 5:
        return AppLocalizations.of(context)!.may_long;
      case 6:
        return AppLocalizations.of(context)!.june_long;
      case 7:
        return AppLocalizations.of(context)!.july_long;
      case 8:
        return AppLocalizations.of(context)!.august_long;
      case 9:
        return AppLocalizations.of(context)!.september_long;
      case 10:
        return AppLocalizations.of(context)!.october_long;
      case 11:
        return AppLocalizations.of(context)!.november_long;
      case 12:
        return AppLocalizations.of(context)!.december_long;
    }
    return "NDEF";
  }
}
