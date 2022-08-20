import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:timekeeperv2/utils/utils.dart';

part 'time_slot.g.dart';

@HiveType(typeId: 1)
class TimeSlot extends HiveObject with Comparable {
  static const String BOX = "TimeSlot";

  TimeSlot(String date, String startTime, String endTime, String? description) {
    _date = date;
    _startTime = startTime;
    _endTime = endTime;
    _description = description;
  }

  TimeSlot.create(DateTime date, TimeOfDay startTime, TimeOfDay endTime,
      String description) {
    _date = date.toIso8601String();
    _startTime = Utils.instance.timeOfTheDayToString(startTime);
    _endTime = Utils.instance.timeOfTheDayToString(endTime);
    _description = description;
  }

  TimeSlot.createEmpty() {
    _date = DateTime.now().toIso8601String();
    TimeOfDay tod = TimeOfDay.now();
    _startTime = Utils.instance.timeOfTheDayToString(tod);
    _endTime = Utils.instance.timeOfTheDayToString(tod);
    _description = "";
  }

  @HiveField(0)
  late String _date;
  DateTime get date => DateTime.parse(_date);
  set date(DateTime date) {
    _date = date.toIso8601String();
  }

  @HiveField(1)
  late String _startTime;
  TimeOfDay get startTime => Utils.instance.parseTimeOfDay(_startTime);
  set startTime(TimeOfDay startTime) {
    _startTime = Utils.instance.timeOfTheDayToString(startTime);
  }

  @HiveField(2)
  late String _endTime;
  TimeOfDay get endTime => Utils.instance.parseTimeOfDay(_endTime);
  set endTime(TimeOfDay endTime) {
    _endTime = Utils.instance.timeOfTheDayToString(endTime);
  }

  @HiveField(3)
  String? _description;
  String? get description => _description;
  set description(String? description) {
    _description = description;
  }

  int get id {
    return key ?? 0;
  }

  int get minutes {
    return int.parse(ISOEndTime) - int.parse(ISOStartTime);
  }

  @override
  int compareTo(other) {
    return ISOFormat.compareTo(other.ISOFormat);
  }

  String get ISOFormat {
    return "$ISODate$ISOStartTime$ISOEndTime";
  }

  String get ISODate {
    return "${Utils.instance.NumberFormat("0", 4, date.year)}${Utils.instance.NumberFormat("0", 2, date.month)}${Utils.instance.NumberFormat("0", 2, date.day)}";
  }

  String get ISOStartTime {
    return "${Utils.instance.NumberFormat("0", 2, startTime.hour)}${Utils.instance.NumberFormat("0", 2, startTime.minute)}";
  }

  String get ISOEndTime {
    return "${Utils.instance.NumberFormat("0", 2, endTime.hour)}${Utils.instance.NumberFormat("0", 2, endTime.minute)}";
  }

  String get csv {
    return "${date.formated("dd.MM.yyyy")};${startTime.hour}:${startTime.minute};${endTime.hour}:${endTime.minute};${Utils.instance.humainReadableMinutesPerHour(minutes)};${Utils.instance.humainReadableDecimalPerHour(minutes)};${description ?? ""}\n";
  }

  Future<bool> addInBox() {
    return TimeSlotHelper().addInBox(this);
    //Hive.box(TimeSlot.BOX).add(this);
  }
}

class TimeSlotList {
  List<TimeSlot> _items = [];

  int get length => _items.length;

  TimeSlot? operator [](int index) {
    return _items[index];
  }

  int get minutes {
    int result = 0;
    _items.forEach((element) {
      result += element.minutes;
    });
    return result;
  }

  int minutesForDay(DateTime dt) {
    int result = 0;
    _items.forEach((element) {
      if (element.date.isSameDateAs(dt)) {
        result += element.minutes;
      }
    });
    return result;
  }

  void add(TimeSlot timeSlot) {
    //ToDo: make sone check statDate < endDate && not overlapp

    _items.add(timeSlot);
  }

  Future<TimeSlotList> perDateInterval(DateTime fromDt, DateTime toDt) {
    return TimeSlotHelper().perDateInterval(fromDt, toDt);
  }

  Future<TimeSlotList> perDate(int year, int month, int day) {
    return TimeSlotHelper().perDate(year, month, day);
  }

  Future<TimeSlotList> perYearMonth(int year, int month) {
    return TimeSlotHelper().perYearMonth(year, month);
  }

  void sortAsc() {
    _items.sort((a, b) => a.compareTo(b));
  }

  void sortDesc() {
    _items.sort((a, b) => b.compareTo(a));
  }

/*
  void loadData() {
    Hive.openBox<TimeSlot>(TimeSlot.BOX).then((value) {
      _items = value.values.toList();
    });
  }
*/
  void delete(TimeSlot ts) {
    TimeSlotHelper().delete(ts);
  }

  String csv() {
    String result = "DATE;FROM;TO;HOUR_MINUTE;HOUR_DECIMAL;DESCRIPTION\n";
    _items.forEach((element) {
      result += element.csv;
    });

    return result;
  }
}

class TimeSlotHelper {
  List<TimeSlot> _items = [];
  Future<Box<TimeSlot>> _box = Hive.openBox<TimeSlot>(TimeSlot.BOX);

  TimeSlotHelper._() {
    _box.then((value) {
      _items = value.values.toList();
    });
  }
  factory TimeSlotHelper() {
    return _instance;
  }
  static final TimeSlotHelper _instance = TimeSlotHelper._();

  Future<bool> existInBox(TimeSlot timeSlot) {
    return _box.then((value) {
      return value.containsKey(timeSlot.key);
    });
  }

  Future<bool> addInBox(TimeSlot timeSlot) async {
    _items.add(timeSlot);
    return _box.then((value) {
      value.add(timeSlot);
      return true;
    });
  }

  Future<TimeSlotList> perDateInterval(DateTime fromDt, DateTime toDt) {
    TimeSlotList result = TimeSlotList();
    //result.removeAll();
    return _box.then((value) {
      _items
          .where((obj) =>
              obj.date.dateItNotation >= fromDt.dateItNotation &&
              obj.date.dateItNotation <= toDt.dateItNotation)
          .forEach((element) => result.add(element));
      result.sortAsc();
      return result;
    });
  }

  Future<TimeSlotList> perDate(int year, int month, int day) {
    return perDateInterval(
        DateTime(year, month, day), DateTime(year, month, day));
  }

  Future<TimeSlotList> perYearMonth(int year, int month) {
    return perDateInterval(
        DateTime(year, month, 1), DateTime(year, month).lastDayOfTheMonth);
  }

  Future<bool> delete(TimeSlot ts) {
    return _box.then((value) {
      value.delete(ts.key);
      _items.remove(ts);
      return true;
    });
  }

  TimeSlotList get emptyList {
    return TimeSlotList();
  }
}
