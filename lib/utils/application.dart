import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../business/working_slot.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';

class Application {
  Application._privateConstructor() {
    /*
    sharedPreferences.then((value) {
      String str = value.getString("START_WORKING") ?? "";
      _startWorking = DateTime.tryParse(str);
      if ((_currentDate != null) &&
          (!DateTime.now().isSameDateAs(_currentDate))) {
        WorkingSlot? ws = endWorking();
        if (ws != null) {
          Application.instance.getWorkingSlotsList().add(ws);
          ws.save();
        }
      }
    });
    */
  }

  static final Application instance = Application._privateConstructor();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  WorkingSlotsList? _workingSlotsList;
  WorkingSlotsList getWorkingSlotsList() {
    if (_workingSlotsList == null) {
      _workingSlotsList = WorkingSlotsList();
      _workingSlotsList!.loadData();
    }
    return _workingSlotsList ?? WorkingSlotsList();
  }

  Future<SharedPreferences> get sharedPreferences {
    return _prefs;
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
    sharedPreferences.then((value) =>
        value.setString("START_WORKING", _startWorking!.toIso8601String()));
  }

  Future<WorkingSlot?> endWorking() async {
    if (_startWorking != null) {
      DateTime endWorking = DateTime.now();
      if (!endWorking.isSameDateAs(_startWorking)) {
        endWorking = DateTime(_startWorking!.year, _startWorking!.month,
            _startWorking!.day, 23, 59);
      }
      WorkingSlot ws = WorkingSlot(
          0,
          _startWorking!,
          TimeOfDay(hour: _startWorking!.hour, minute: _startWorking!.minute),
          TimeOfDay(hour: endWorking.hour, minute: endWorking.minute),
          "");
      ws.description = ""; // needed to set the stats
      _startWorking = null;
      sharedPreferences.then((value) => value.remove("START_WORKING"));
      return ws;
    }
  }

  Future<bool> isWorking() async {
    return _prefs.then((value) {
      return value.getString("START_WORKING") != null;
    });
  }
}
