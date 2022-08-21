import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timekeeperv2/business/time_slot.dart';

import 'package:timekeeperv2/utils/date_extensions.dart';

class Application {
  Application._privateConstructor();
  static const String _START_WORKING = "START_WORKING";
  static const String _LOCALE_LANGUAGE = "LOCALE_LANGUAGE";
  static const String _LOCALE_COUNTRY = "LOCALE_COUNTRY";

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
}
