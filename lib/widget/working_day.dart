import 'dart:async';

import 'package:flutter/material.dart';

import 'package:timekeeperv2/business/working_slot.dart';

import 'package:timekeeperv2/utils/application.dart';

import 'package:timekeeperv2/widget/daily_picker.dart';

//import 'package:weekly_date_picker/weekly_date_picker.dart';
import 'package:timekeeperv2/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timekeeperv2/widget/working_baseline.dart';

class WorkingDayWidget extends StatefulWidget {
  WorkingDayWidget({Key? key}) : super(key: key);

  @override
  _WorkingDayWidget createState() => _WorkingDayWidget();
}

class _WorkingDayWidget extends State<WorkingDayWidget> {
  _WorkingDayWidget();

  late WorkingSlotsList slotListFiltered;
  late ScrollController _controller;

  late int _sumMinutes = 0;

  @protected
  void setDate(DateTime value) {
    Application.instance.getWorkingSlotsList().checkList();
    slotListFiltered = Application.instance
        .getWorkingSlotsList()
        .perDate(value.year, value.month, value.day);
    setState(() {
      _sumMinutes = slotListFiltered.sumMinutes();
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

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _sumMinutes = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //DateTime _selectedDay = DateTime.now();
    setDate(Application.instance.getCurrentDate());
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 115,
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 100,
                child: DailyPicker(
                    selectedDay: Application.instance.getCurrentDate(),
                    changeDay: (value) {
                      setDate(value);
                    },
                    enableWeeknumberText: true,
                    weeknumberColor: Colors.blue,
                    weeknumberTextColor: Colors.white,
                    backgroundColor: Colors.blue,
                    weekdayTextColor: Colors.white,
                    digitsColor: Colors.white,
                    selectedBackgroundColor: Colors.white,
                    selectedDigitColor: Colors.black,
                    weekdays: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"],
                    daysInWeek: 7)),
            Container(
                height: MediaQuery.of(context).size.height - 115 - 100 - 60,
                child: SingleChildScrollView(
                    child: Column(children: [
                  SlidableAutoCloseBehavior(
                      child: ListView.builder(
                    itemBuilder: (BuildContext, index) {
                      return Slidable(
                          closeOnScroll: true,
                          groupTag: "TAG0",
                          endActionPane:
                              ActionPane(motion: ScrollMotion(), children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              flex: 2,
                              onPressed: (context) {
                                Navigator.pushNamed(context, '/edit',
                                        arguments: slotListFiltered[index])
                                    .then(onPop);
                              },
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text("Alert Dialog Box"),
                                          content: const Text(
                                              "Do you wich to delete this working time ? "),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                slotListFiltered[index]!
                                                    .toDelete();
                                                slotListFiltered[index]!.save();
                                                setDate(Application.instance
                                                    .getCurrentDate());
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                color: Colors.grey,
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: const Text("ok"),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                color: Colors.grey,
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: const Text("cancel"),
                                              ),
                                            ),
                                          ],
                                        ));
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ]),
                          child: Card(
                            child: ListTile(
                              title: Text(Utils.instance.longHour(
                                      slotListFiltered[index]!.startTime) +
                                  " - " +
                                  Utils.instance.longHour(
                                      slotListFiltered[index]!.endTime) +
                                  " " +
                                  Utils.instance.humainReadableMinutes(
                                      slotListFiltered[index]!.minutes)),
                              subtitle: Text(
                                  slotListFiltered[index]!.description ?? "XX"),
                            ),
                          ));
                    },
                    itemCount: slotListFiltered.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    scrollDirection: Axis.vertical,
                    primary: false,
                  ))
                ]))),
            WorkingBaseline(
              minutes: _sumMinutes,
              onPop: onPop,
            )
          ],
        ));
  }

  FutureOr onPop(Object? value) {
    setDate(Application.instance.getCurrentDate());
  }
}
