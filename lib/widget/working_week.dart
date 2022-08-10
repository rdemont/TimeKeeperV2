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

class WorkingWeekWidget extends StatefulWidget {
  WorkingWeekWidget({Key? key}) : super(key: key);

  @override
  _WorkingWeekWidget createState() => _WorkingWeekWidget();
}

class _WorkingWeekWidget extends State<WorkingWeekWidget> {
  _WorkingWeekWidget();

  late WorkingSlotsList slotListFiltered;
  late ScrollController _controller;

  @protected
  void setDate(DateTime value) {
    Application.instance.getWorkingSlotsList().checkList();
    slotListFiltered = Application.instance
        .getWorkingSlotsList()
        .perDate(value.year, value.month, value.day);
    setState(() {
      Application.instance.setCurrentDate(value);
    });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        //message = "reach the bottom";
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        //message = "reach the top";
      });
    }
  }

  List<Widget> itemWeek = [];
  int totMinutes = 0;

  Widget createDayOfTheWeek(DateTime dt) {
    Color bgColor = Colors.white;
    if ((dt.weekday == DateTime.saturday) || (dt.weekday == DateTime.sunday)) {
      bgColor = Colors.grey;
    }
    WorkingSlotsList wsl = Application.instance
        .getWorkingSlotsList()
        .perDate(dt.year, dt.month, dt.day);
    totMinutes += wsl.sumMinutes();
    Widget result = GestureDetector(
        onTap: () {
          btnDailyVisible = false;
          btnWeeklyVisible = true;
          btnMonthlyVisible = true;

          Application.instance.setCurrentDate(dt);
          Navigator.popAndPushNamed(context, '/daily');
        },
        child: Container(
            height: 50,
            color: bgColor,
            alignment: AlignmentDirectional.centerStart,
            padding: EdgeInsets.fromLTRB(10, 5, 50, 5),
            child: Column(children: [
              Text(
                  "${Utils.instance.dayOftheWeekLong(dt)} ${dt.day} ${dt.formated("MMMM")} ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black)),
              Text("${Utils.instance.humainReadableMinutes(wsl.sumMinutes())}")
            ]))); //: ));
    return result;
  }

  String _weekFromToFactory(DateTime dt) {
    return dt.firstDayOfTheWeek.formated("dd.MM.yyyy") +
        " - " +
        dt.lastDayOfTheWeek.formated("dd.MM.yyyy");
  }

  late DateTime _currentDate;
  late int _weekNumber;
  late int _yearNumber;

  late String _weekFromTo;

  void _changeDate(DateTime dt) {
    _currentDate = dt;
    _weekNumber = _currentDate.weekOfYear;
    _yearNumber = _currentDate.year;
    _weekFromTo = _weekFromToFactory(_currentDate);
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();

    _changeDate(Application.instance.getCurrentDate());
  }

  @override
  Widget build(BuildContext context) {
    setDate(Application.instance.getCurrentDate());
    DateTime dt = Application.instance.getCurrentDate();
    itemWeek.clear();
    totMinutes = 0;
    DateTime dayD = dt.firstDayOfTheWeek;
    for (int i = 0; i < 7; i++) {
      itemWeek.add(createDayOfTheWeek(dayD));
      dayD = dayD.add(Duration(days: 1));
    }
    return Dismissible(
        key: Key("${_weekFromTo}"),
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          setState(() {
            print(direction == DismissDirection.endToStart ? "1" : "-1");
            if (direction == DismissDirection.endToStart) {
              _currentDate = _currentDate.add(Duration(days: 7));
              Application.instance.setCurrentDate(_currentDate);
              _changeDate(_currentDate);
            } else {
              _currentDate = _currentDate.add(Duration(days: -7));
              Application.instance.setCurrentDate(_currentDate);
              _changeDate(_currentDate);
            }
          });
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 115,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 80,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    color: Colors.blue,
                    child: Row(
                      children: [
                        TextButton(
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
                        ),
                        Container(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 10,
                            ),
                            Text("Week $_weekNumber / $_yearNumber",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white)),
                            Text(_weekFromTo,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white))
                          ],
                        )
                      ],
                    )),
                Container(
                    height: MediaQuery.of(context).size.height - 115 - 80 - 60,
                    child: ListView.builder(
                        itemCount: itemWeek.length,
                        itemBuilder: (context, index) {
                          return itemWeek[index];
                        })),
                WorkingBaseline(
                  minutes: totMinutes,
                  onPop: onPop,
                )
              ],
            )));

    //return result;
  }

  FutureOr onPop(Object? value) {
    setDate(Application.instance.getCurrentDate());
  }
}
