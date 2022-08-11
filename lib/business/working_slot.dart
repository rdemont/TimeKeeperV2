//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

import 'package:timekeeperv2/sql/working_slot_db.dart';
import 'package:timekeeperv2/utils/utils.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';

class WorkingSlot extends Comparable {
  static int STATE_NONE = 0;
  static int STATE_UPDATED = 1;
  static int STATE_DELETED = 99;

  WorkingSlotDB wsDB = WorkingSlotDB();

  late int _id;
  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay? _endTime;
  late String? _description;
  //bool _valid = false;
  int _state = STATE_NONE;
  int get id => _id;
  void set id(int id) {
    _id = id;
  }

  String? get description => _description;
  void set description(String? description) {
    _description = description;
    _state = STATE_UPDATED;
  }

/*
  void set valid(bool valid) {
    _valid = valid;
  }
*/
  int get year => _date.year;
  int get month => _date.month;
  int get day => _date.day;

  int get startHour => _startTime.hour;
  int get startMinute => _startTime.minute;

  TimeOfDay get startTime => _startTime;
  TimeOfDay? get endTime => _endTime;

  void set startTime(TimeOfDay timeOfDay) {
    _startTime = timeOfDay;
    _state = STATE_UPDATED;
  }

  void set endTime(TimeOfDay? timeOfDay) {
    _endTime = timeOfDay;
    _state = STATE_UPDATED;
  }

  DateTime get date => _date;

  void set date(DateTime date) {
    _date = date;
    _state = STATE_UPDATED;
  }

  int? get endHour {
    if (_endTime == null) {
      return null;
    } else {
      return _endTime!.hour;
    }
  }

  int? get endMinute {
    if (_endTime == null) {
      return null;
    } else {
      return _endTime!.minute;
    }
  }

  int get minutes {
    if (_endTime == null) return 0;
    return (((endHour ?? 0) - startHour) * 60) +
        ((endMinute ?? 0) - startMinute);
  }

  String get csv {
    return "_${date.formated("dd.MM.YYYY")};${_startTime.hour}:${_startTime.minute};${_endTime!.hour}:${_endTime!.minute};${_description ?? ""}";
  }

  WorkingSlot(int id, DateTime date, TimeOfDay startTime, TimeOfDay? endTime,
      String? description) {
    _id = id;
    _date = date;
    _startTime = startTime;
    _endTime = endTime;
    _description = description;

    _state = STATE_NONE;
  }

  void save() {
    if (_state == STATE_DELETED) {
      wsDB.delete(_id);
    }
    if (_state > STATE_NONE) {
      wsDB.save(this);
    }
  }

  void toDelete() {
    _state = STATE_DELETED;
  }

  WorkingSlot.fromMap(Map<String, dynamic> map) {
    _id = map[WorkingSlotDB.COL_ID];
    _date = DateTime.parse(map[WorkingSlotDB.COL_DATE]);
    _startTime =
        Utils.instance.parseTimeOfDay(map[WorkingSlotDB.COL_STARTTIME]);
    _endTime = Utils.instance.parseTimeOfDay(map[WorkingSlotDB.COL_ENDTIME]);
    _description = map[WorkingSlotDB.COL_DESCRIPTION];
    //_valid = true;
  }

  Map<String, dynamic> toMap() {
    return {
      WorkingSlotDB.COL_ID: _id,
      WorkingSlotDB.COL_DATE: _date.toIso8601String(),
      WorkingSlotDB.COL_STARTTIME:
          Utils.instance.timeOfTheDayToString(_startTime),
      WorkingSlotDB.COL_ENDTIME: Utils.instance.timeOfTheDayToString(_endTime),
      WorkingSlotDB.COL_DESCRIPTION: _description,
    };
  }

  @override
  int compareTo(other) {
    return ISOFormat.compareTo(other.ISOFormat);
  }

  String get ISOFormat {
    return "$ISODate$ISOStartTime$ISOEndTime";
  }

  String get ISODate {
    return "${Utils.instance.NumberFormat("0", 4, _date.year)}${Utils.instance.NumberFormat("0", 2, _date.month)}${Utils.instance.NumberFormat("0", 2, _date.day)}";
  }

  String get ISOStartTime {
    return "${Utils.instance.NumberFormat("0", 2, _startTime.hour)}${Utils.instance.NumberFormat("0", 2, _startTime.minute)}";
  }

  String get ISOEndTime {
    return "${Utils.instance.NumberFormat("0", 2, _endTime?.hour ?? 0)}${Utils.instance.NumberFormat("0", 2, _endTime?.minute ?? 0)}";
  }

  @override
  String toString() {
    return "$_id [${this.ISOFormat}";
  }
}

class WorkingSlotsList {
  late List<WorkingSlot> slotList = [];

  @override
  String toString() {
    String result = "";
    slotList.forEach((row) => result += "-${row.toString()}");

    return result;
  }

  void sortAsc() {
    //print("****NO sorted ${this.toString()}");
    slotList.sort((a, b) => a.compareTo(b));
    //print("*******Sorted ${this.toString()}");
  }

  void sortDesc() {
    //print("****NO sorted ${this.toString()}");
    slotList.sort((a, b) => b.compareTo(a));
    //print("*******Sorted ${this.toString()}");
  }

  WorkingSlotDB wsDB = WorkingSlotDB();

  WorkingSlot newWorkingSlot(DateTime date, TimeOfDay startTime,
      TimeOfDay? endTime, String? description) {
    WorkingSlot newWS =
        new WorkingSlot(0, date, startTime, endTime, description);
    slotList.add(newWS);
    return newWS;
  }

  _loadData() async {
    slotList.clear();
    List<Map<String, dynamic>> list = await wsDB.queryAllRows();
    list.forEach((row) => slotList.add(WorkingSlot.fromMap(row)));
  }

  WorkingSlotsList() {
    _loadData();
  }

  void checkList() {
    print("**CheckList Before** ${this.toString()}");

    if (slotList.isNotEmpty) {
      /*
      sortAsc();
      WorkingSlot last = slotList[0];
      for (var i = 1; i < slotList.length; i++) {
        WorkingSlot cur = slotList[i];
        if (cur._state != WorkingSlot.STATE_DELETED) {
          if (last.ISODate == cur.ISODate) {
            if (int.parse(last.ISOEndTime) >= int.parse(cur.ISOStartTime)) {
              //Merge
              slotList[i].toDelete();
              if (int.parse(last.ISOEndTime) < int.parse(cur.ISODate)) {
                last.endTime = cur.endTime;
              }
              if (last.description != null) {
                last.description =
                    "${last.description}@${cur.description ?? ""}";
              }
            }
          }
          last = cur;
        }
      }
      */
      List<WorkingSlot> removeList = [];

      slotList
          .where((obj) => (obj._state == WorkingSlot.STATE_DELETED))
          .toList()
          .forEach((element) => removeList.add(element));

      removeList.forEach((element) {
        slotList.remove(element);
      });
    }
    print("**CheckList After** ${this.toString()}");
  }

  WorkingSlot? operator [](int index) {
    return slotList[index];
  }

  void add(WorkingSlot workingSlot) {
    //ToDo: make sone check statDate < endDate && not overlapp

    slotList.add(workingSlot);
  }

  void remove(int id) {
    slotList.removeWhere((element) => element._id == id);
  }

  void removeAll() {
    slotList.clear();
  }

  int get length => slotList.length;

  WorkingSlotsList perYear(int year) {
    WorkingSlotsList result = WorkingSlotsList();
    result.removeAll();
    slotList
        .where((obj) => obj.year == year)
        .toList()
        .forEach((element) => result.add(element));

    result.sortAsc();
    return result;
  }

  WorkingSlotsList perYearMonth(int year, int month) {
    WorkingSlotsList result = WorkingSlotsList();
    result.removeAll();
    slotList
        .where((obj) => ((obj.year == year) && (obj.month == month)))
        .toList()
        .forEach((element) => result.add(element));
    result.sortAsc();
    return result;
  }

  WorkingSlotsList perDate(int year, int month, int day) {
    WorkingSlotsList result = WorkingSlotsList();
    result.removeAll();
    slotList
        .where((obj) =>
            obj.year == year &&
            obj.month == month &&
            obj.day == day &&
            obj._state != WorkingSlot.STATE_DELETED)
        .forEach((element) => result.add(element));
    result.sortAsc();
    return result;
  }

  int sumMinutes() {
    int result = 0;
    slotList.forEach((element) {
      result += element.minutes;
    });
    return result;
  }

  String csv() {
    String result = "";
    slotList.forEach((element) {
      result += element.csv;
    });
    return result;
  }
}
