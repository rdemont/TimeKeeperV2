import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timekeeperv2/business/time_slot.dart';

import 'package:timekeeperv2/utils/date_extensions.dart';

class Application {
  Application._privateConstructor();
  static const String _START_WORKING = "START_WORKING";
  static const String _LOCALE_LANGUAGE = "LOCALE_LANGUAGE";
  static const String _LOCALE_COUNTRY = "LOCALE_COUNTRY";
  static const String _WORKING_DAYS = "WORING_DAYS";
  static const String _STEP_PER_HOUR = "_STEP_PER_HOUR";
  static const String _HOUR_PER_DAY = "_HOUR_PER_DAY";

  static const int _MONDAY = 1;
  static const int _TUESDAY = 2;
  static const int _WEDNESDAY = 4;
  static const int _THURSDAY = 8;
  static const int _FRIDAY = 16;
  static const int _SATERDAY = 32;
  static const int _SUNDAY = 64;
  static const int _DEFAULT_WORKINGDAYS =
      _MONDAY | _TUESDAY | _WEDNESDAY | _THURSDAY | _FRIDAY;
  static const int _DEFAULT_STEP_PER_HOUR = 15;

  static final Application instance = Application._privateConstructor();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void startWorking() {
    _prefs.then((value) =>
        value.setString(_START_WORKING, DateTime.now().toIso8601String()));
  }

  Future<TimeSlot?> endWorking() async {
    return _prefs.then((value) {
      String? startTime = value.getString(_START_WORKING);
      if (startTime != null) {
        DateTime dt = DateTime.parse(startTime);
        DateTime endWorking = DateTime.now();
        if (!endWorking.isSameDateAs(dt)) {
          endWorking = DateTime(dt.year, dt.month, dt.day, 23, 59);
        }
        value.remove(_START_WORKING);
        return TimeSlot.create(dt, TimeOfDay(hour: dt.hour, minute: dt.minute),
            TimeOfDay(hour: endWorking.hour, minute: endWorking.minute), "");
      } else {
        startWorking();
      }
    });
  }

  Future<bool> isWorking() async {
    return _prefs.then((value) {
      return value.getString(_START_WORKING) != null;
    });
  }

  void set locale(Locale _locale) {
    _prefs.then((value) {
      value.setString(_LOCALE_LANGUAGE, _locale.languageCode);
      if (_locale.countryCode != null) {
        value.setString(_LOCALE_COUNTRY, _locale.countryCode ?? "");
      }
    });
  }

  Future<Locale> getLocale(Locale defaultValue) {
    return _prefs.then((value) {
      if (value.containsKey(_LOCALE_LANGUAGE)) {
        String languageCode =
            value.getString(_LOCALE_LANGUAGE) ?? defaultValue.languageCode;
        String? countryCode = value.getString(_LOCALE_COUNTRY);
        return Locale(languageCode, countryCode);
      } else {
        return defaultValue;
      }
    });
  }

  void setWorkingDays(bool isMonday, bool isTuesday, bool isWednesday,
      bool isThursday, bool isFriday, bool isSaterday, bool isSunday) {
    _prefs.then((value) {
      int ind = 0;
      ind = (isMonday ? (ind | _MONDAY) : (ind & ~_MONDAY));
      ind = (isTuesday ? (ind | _TUESDAY) : (ind & ~_TUESDAY));
      ind = (isWednesday ? (ind | _WEDNESDAY) : (ind & ~_WEDNESDAY));
      ind = (isThursday ? (ind | _THURSDAY) : (ind & ~_THURSDAY));
      ind = (isFriday ? (ind | _FRIDAY) : (ind & ~_FRIDAY));
      ind = (isSaterday ? (ind | _SATERDAY) : (ind & ~_SATERDAY));
      ind = (isSunday ? (ind | _SUNDAY) : (ind & ~_SUNDAY));
      value.setInt(_WORKING_DAYS, ind);
    });
  }

  Future<bool> get workingDayMonday {
    return _prefs.then((value) {
      return ((value.getInt(_WORKING_DAYS) ?? _DEFAULT_WORKINGDAYS) &
              _MONDAY) ==
          _MONDAY;
    });
  }

  Future<bool> get workingDayTuesday {
    return _prefs.then((value) {
      return ((value.getInt(_WORKING_DAYS) ?? _DEFAULT_WORKINGDAYS) &
              _TUESDAY) ==
          _TUESDAY;
    });
  }

  Future<bool> get workingDayWedesday {
    return _prefs.then((value) {
      return ((value.getInt(_WORKING_DAYS) ?? _DEFAULT_WORKINGDAYS) &
              _WEDNESDAY) ==
          _WEDNESDAY;
    });
  }

  Future<bool> get workingDayThursday {
    return _prefs.then((value) {
      return ((value.getInt(_WORKING_DAYS) ?? _DEFAULT_WORKINGDAYS) &
              _THURSDAY) ==
          _THURSDAY;
    });
  }

  Future<bool> get workingDayFriday {
    return _prefs.then((value) {
      return ((value.getInt(_WORKING_DAYS) ?? _DEFAULT_WORKINGDAYS) &
              _FRIDAY) ==
          _FRIDAY;
    });
  }

  Future<bool> get workingDaySaterday {
    return _prefs.then((value) {
      return ((value.getInt(_WORKING_DAYS) ?? _DEFAULT_WORKINGDAYS) &
              _SATERDAY) ==
          _SATERDAY;
    });
  }

  Future<bool> get workingDaySunday {
    return _prefs.then((value) {
      return ((value.getInt(_WORKING_DAYS) ?? _DEFAULT_WORKINGDAYS) &
              _SUNDAY) ==
          _SUNDAY;
    });
  }

  void setStepHour(int step) {
    _prefs.then((value) {
      value.setInt(_STEP_PER_HOUR, step);
    });
  }

  Future<int> get stepHour {
    return _prefs.then((value) {
      return (value.getInt(_STEP_PER_HOUR) ?? _DEFAULT_STEP_PER_HOUR);
    });
  }

  void setHourPerDay(double hourPerDay) {
    _prefs.then((value) {
      value.setDouble(_HOUR_PER_DAY, hourPerDay);
    });
  }

  Future<double> get hourPerDay {
    return _prefs.then((value) {
      return (value.getDouble(_HOUR_PER_DAY) ?? 0.0);
    });
  }

  Future<int> get minutesPerDay {
    return hourPerDay.then((value) {
      return (value.toInt() * 60) + ((value - value.toInt()) * 100).toInt();
    });
  }
}
