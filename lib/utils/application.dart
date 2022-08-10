import 'package:flutter/material.dart';

import '../business/working_slot.dart';

class Application {
  Application._privateConstructor();

  static final Application instance = Application._privateConstructor();

  WorkingSlotsList? _workingSlotsList;
  WorkingSlotsList getWorkingSlotsList() {
    if (_workingSlotsList == null) {
      _workingSlotsList = WorkingSlotsList();
    }
    return _workingSlotsList ?? WorkingSlotsList();
  }

  refreshWorkingSlotsList() {
    _workingSlotsList = new WorkingSlotsList();
  }

  DateTime? _currentDate;
  DateTime getCurrentDate() {
    return _currentDate ?? DateTime.now();
  }

  setCurrentDate(DateTime dateTime) {
    _currentDate = dateTime;
  }

  DateTime? _startWorking;
  void startWorking() {
    _startWorking = DateTime.now();
  }

  WorkingSlot? endWorking() {
    if (_startWorking != null) {
      WorkingSlot ws = WorkingSlot(
          0,
          _startWorking!,
          TimeOfDay(hour: _startWorking!.hour, minute: _startWorking!.minute),
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
          "");
      _startWorking = null;
      return ws;
    }
  }

  bool isWorking() {
    return _startWorking != null;
  }
}
