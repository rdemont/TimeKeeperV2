import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:timekeeperv2/business/working_slot.dart';
import 'package:timekeeperv2/main.dart';

import 'package:timekeeperv2/utils/application.dart';

import 'package:timekeeperv2/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:timekeeperv2/widget/working_baseline.dart';

class WorkingMonthlyWidget extends StatefulWidget {
  WorkingMonthlyWidget({Key? key}) : super(key: key);

  @override
  _WorkingMonthlyWidget createState() => _WorkingMonthlyWidget();
}

class _WorkingMonthlyWidget extends State<WorkingMonthlyWidget> {
  _WorkingMonthlyWidget();

  @protected
  void setDate(DateTime value) {
    Application.instance.getWorkingSlotsList().checkList();
    Application.instance.setCurrentDate(value);
  }

  late DateTime _currentDate;
  late String _key;
  late String _monthTitle;
  int _minutesMonth = 0;

  void _changeDate(DateTime dt) {
    _currentDate = dt;
    createMonth(_currentDate);
    _monthTitle = "${Utils.instance.MonthName(dt)} / ${dt.year}";
    _key = _monthTitle;

    createMonth(dt);

    for (int i = 0; i < _weeksMinutes.length; i++) {
      _minutesMonth += _weeksMinutes[i];
    }
  }

  @override
  void initState() {
    super.initState();
    _widthCel = 20;
    _heightCel = 20;
    _changeDate(Application.instance.getCurrentDate());
  }

  List _monthItem = [];
  List<int> _weeksMinutes = [];
  late double _widthCel;
  late double _heightCel;

  Widget createDayOfWeek(int index) {
    String str = "";
    Color fontColor = Colors.black;
    switch (index) {
      case 0:
        str = "Mo";
        break;
      case 1:
        str = "Tu";
        break;
      case 2:
        str = "We";
        break;
      case 3:
        str = "Th";
        break;
      case 4:
        str = "Fr";
        break;
      case 5:
        str = "Sa";
        fontColor = Colors.white;
        break;
      case 6:
        str = "Su";
        fontColor = Colors.white;
        break;
    }
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          "$str",
          style: TextStyle(
              fontSize: 20, color: fontColor, fontWeight: FontWeight.bold),
        ));
  }

  Widget createWeekTotal(int index, DateTime dt, int firstWeek) {
    int minutes = _weeksMinutes[dt.weekOfYear - firstWeek];
    return GestureDetector(
        onTap: () {
          Application.instance.setCurrentDate(dt);
          //btnDailyVisible = false;
          //btnWeeklyVisible = true;
          //btnMonthlyVisible = false;
          Navigator.popAndPushNamed(context, '/weekly');
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "week ${dt.weekOfYear}",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${Utils.instance.humainReadableMinutesPerHour(minutes)}",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Text(
                  "${Utils.instance.humainReadableDecimalPerHour(minutes)}",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                )
              ],
            )));
  }

  Widget createDay(DateTime dt, int firstweek) {
    int minutes = Application.instance
        .getWorkingSlotsList()
        .perDate(dt.year, dt.month, dt.day)
        .sumMinutes();
    _weeksMinutes[dt.weekOfYear - firstweek] += minutes;
    Color fontColor = Colors.black;
    if ((dt.weekday == DateTime.saturday) || (dt.weekday == DateTime.sunday)) {
      fontColor = Colors.white;
    }
    return GestureDetector(
        onTap: () {
          Application.instance.setCurrentDate(dt);
          //btnDailyVisible = false;
          //btnWeeklyVisible = true;
          //btnMonthlyVisible = true;
          Navigator.popAndPushNamed(context, '/daily');
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${dt.day}.${dt.month}",
                  style: TextStyle(
                      fontSize: 15,
                      color: fontColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${Utils.instance.humainReadableMinutesPerHour(minutes)}",
                  style: TextStyle(fontSize: 15, color: fontColor),
                ),
                Text(
                  "${Utils.instance.humainReadableDecimalPerHour(minutes)}",
                  style: TextStyle(fontSize: 15, color: fontColor),
                ),
              ],
            )));
  }

  void createMonth(DateTime dateTime) {
    _monthItem.clear();
    _weeksMinutes = List<int>.filled(5, 0);

    DateTime dtStart = dateTime.firstDayOfTheMonth;
    while (dtStart.weekday != DateTime.monday) {
      dtStart = dtStart.add(Duration(days: -1));
    }
    int firstWeek = dtStart.weekOfYear;
    DateTime dt = dtStart;
    DateTime dtNext = dtStart;
    DateTime dtweek = dtStart;

    for (int i = 0; i < 48; i++) {
      if ((i % 6) == 0) {
        _monthItem.add(createDayOfWeek(i ~/ 6));
      } else {
        if (i >= 43) {
          _monthItem.add(createWeekTotal(i, dtweek, firstWeek));
          dtweek = dtweek.add(Duration(days: 7));
        } else {
          _monthItem.add(createDay(dt, firstWeek));
          if (((i + 1) % 6) == 0) {
            dtNext = dtNext.add(Duration(days: 1));
            dt = dtNext;
          } else {
            dt = dt.add(Duration(days: 7));
          }
        }
      }
    }
  }

  Widget _workingday(int index) {
    Color bgColor = Colors.white;
    if (index >= 30) bgColor = Colors.grey;
    if ((index >= 6) && (index < 12))
      bgColor = Color.fromARGB(255, 228, 227, 227);
    if ((index >= 18) && (index < 24))
      bgColor = Color.fromARGB(255, 228, 227, 227);
    if (index >= 42) bgColor = Colors.blueGrey;
    return Container(
        height: _heightCel,
        width: _widthCel,
        color: bgColor,
        child: _monthItem[index]);
  }

  double _screenTop = 118;
  double _screenSelect = 80;
  double _scrrenBottom = 60;

  @override
  Widget build(BuildContext context) {
    _widthCel = MediaQuery.of(context).size.width / 6;
    _heightCel = (MediaQuery.of(context).size.height -
            _screenTop -
            _screenSelect -
            _scrrenBottom) /
        8;

    return Dismissible(
        key: Key("${_key}"),
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          setState(() {
            print(direction == DismissDirection.endToStart ? "1" : "-1");
            if (direction == DismissDirection.endToStart) {
              _currentDate = new DateTime(
                  _currentDate.year, _currentDate.month + 1, _currentDate.day);
              Application.instance.setCurrentDate(_currentDate);
              _changeDate(_currentDate);
            } else {
              _currentDate = new DateTime(
                  _currentDate.year, _currentDate.month - 1, _currentDate.day);
              Application.instance.setCurrentDate(_currentDate);
              _changeDate(_currentDate);
            }
          });
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - _screenTop,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: _screenSelect,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    color: Colors.blue,
                    child: Row(
                      children: [
                        Container(
                            width: 100,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue.shade900,
                                shape: const BeveledRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                              onPressed: () {
                                setState(() {
                                  Application.instance
                                      .setCurrentDate(DateTime.now());
                                  _changeDate(DateTime.now());
                                });
                              },
                              child: const Text("Today",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white)),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width - 140,
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(_monthTitle,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.white)),
                                Text("TBD",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white)),
                              ],
                            ))
                      ],
                    )),
                Container(
                    color: Colors.pink,
                    height: MediaQuery.of(context).size.height -
                        _screenTop -
                        _screenSelect -
                        _scrrenBottom,
                    child: GridView.count(
                        primary: false,
                        crossAxisCount: 6,
                        children: List.generate(48, (index) {
                          return _workingday(index);
                        }))),
                Container(
                    height: _scrrenBottom,
                    color: Colors.yellow,
                    child: WorkingBaseline(
                      minutes: _minutesMonth,
                      onPop: onPop,
                    )),
              ],
            )));

    //return result;
  }

  FutureOr onPop(Object? value) {
    setDate(Application.instance.getCurrentDate());
  }
}
