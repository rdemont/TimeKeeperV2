import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  bool isAfter(TimeOfDay timeOfDay) {
    return ((hour > timeOfDay.hour) ||
        ((hour == timeOfDay.hour) && (minute > timeOfDay.minute)));
  }

  bool isBefore(TimeOfDay timeOfDay) {
    return ((hour < timeOfDay.hour) ||
        ((hour == timeOfDay.hour) && (minute < timeOfDay.minute)));
  }
}
