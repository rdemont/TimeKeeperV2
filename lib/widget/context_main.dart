import 'package:flutter/material.dart';
import 'package:timekeeperv2/business/working_slot.dart';
import 'package:timekeeperv2/main.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utils/utils.dart';
import 'daily_picker.dart';
import 'main_page.dart';

class ContextMainWidget extends StatefulWidget {
  ContextMainWidget(
      {Key? key,
      required this.height,
      required this.width,
      required this.currentDate,
      required this.viewType,
      required this.onChange,
      required this.onEdit,
      required this.workingSlotsList})
      : super(key: key);

  final double height;
  final double width;
  DateTime currentDate;
  WorkingSlotsList workingSlotsList;
  int viewType;
  final Function(DateTime currentDate, int type) onChange;
  final Function(WorkingSlot? ws) onEdit;

  @override
  _ContextMainWidget createState() => _ContextMainWidget();
}

class _ContextMainWidget extends State<ContextMainWidget> {
  _ContextMainWidget();

  Widget getDaily() {
    return ListView.builder(
        itemCount: widget.workingSlotsList.length,
        itemBuilder: (BuildContext, index) {
          return Slidable(
              closeOnScroll: true,
              groupTag: "TAG0",
              endActionPane: ActionPane(motion: ScrollMotion(), children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 2,
                  onPressed: (context) {
                    widget.onEdit(widget.workingSlotsList[index]);
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
                                    widget.workingSlotsList[index]!.toDelete();
                                    widget.workingSlotsList[index]!.save();
                                    //setDate(Application.instance.getCurrentDate());
                                    //Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    color: Colors.grey,
                                    padding: const EdgeInsets.all(14),
                                    child: const Text("ok"),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    color: Colors.grey,
                                    padding: const EdgeInsets.all(14),
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
                title: Row(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("From : "),
                      Text("To : "),
                    ],
                  ),
                  Column(children: [
                    Text(Utils.instance
                        .longHour(widget.workingSlotsList[index]!.startTime)),
                    Text(Utils.instance
                        .longHour(widget.workingSlotsList[index]!.endTime)),
                  ]),
                  Container(
                    width: 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Total in minuts : "),
                      Text("Total in decimal : "),
                    ],
                  ),
                  Column(
                    children: [
                      Text(Utils.instance.humainReadableMinutesPerHour(
                          widget.workingSlotsList[index]!.minutes)),
                      Text(Utils.instance.humainReadableMinutesPerHour(
                          widget.workingSlotsList[index]!.minutes))
                    ],
                  ),
                ]),
                subtitle:
                    Text(widget.workingSlotsList[index]!.description ?? ""),
              )));
        });
  }

  Widget createDayOfTheWeek(DateTime dt) {
    Color bgColor = Colors.white;
    int totMinutes = 0;
    if ((dt.weekday == DateTime.saturday) || (dt.weekday == DateTime.sunday)) {
      bgColor = Colors.grey;
    }
    WorkingSlotsList wsl =
        widget.workingSlotsList.perDate(dt.year, dt.month, dt.day);
    totMinutes += wsl.sumMinutes();
    Widget result = GestureDetector(
        onTap: () {
          widget.onChange(dt, ViewType.VIEW_TYPE_DAILY);
        },
        child: Container(
            height: widget.height / 7,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(wsl.sumMinutes() > 0 ? "In hour and Minutes : " : ""),
                  Text(
                      "${Utils.instance.humainReadableMinutesPerHour(wsl.sumMinutes())}")
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(wsl.sumMinutes() > 0 ? "In hour and decimal : " : ""),
                Text(
                    "${Utils.instance.humainReadableDecimalPerHour(wsl.sumMinutes())}")
              ])
            ]))); //: ));
    return result;
  }

  Widget getWeekly() {
    List<Widget> itemWeek = [];
    DateTime dayD = widget.currentDate.firstDayOfTheWeek;
    for (int i = 0; i < 7; i++) {
      itemWeek.add(createDayOfTheWeek(dayD));
      dayD = dayD.add(Duration(days: 1));
    }
    return ListView.builder(
        itemCount: itemWeek.length,
        itemBuilder: (context, index) {
          return itemWeek[index];
        });
  }

  Widget _montlyWorkingday(int index, List monthItem) {
    //double widthCel = widget.width / 6;
    //double heightCel = widget.height / 8;

    Color bgColor = Colors.white;

    //weekend
    if (index >= 30) bgColor = Colors.grey;

    //odd line
    if ((index >= 6) && (index < 12))
      bgColor = Color.fromARGB(255, 202, 202, 202);
    if ((index >= 18) && (index < 24))
      bgColor = Color.fromARGB(255, 202, 201, 201);

    //week result
    if (index >= 42) bgColor = Colors.blueGrey;
    return Container(
        //height: heightCel,
        //width: widthCel,
        color: bgColor,
        child: monthItem[index]);
  }

  Widget monthCreateDayOfWeek(int index) {
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
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          "$str",
          style: TextStyle(
              fontSize: 20, color: fontColor, fontWeight: FontWeight.bold),
        ));
  }

  Widget monthCreateWeekTotal(
      int index, DateTime dt, int firstWeek, List weekMinutes) {
    int minutes = weekMinutes[dt.weekOfYear - firstWeek];
    return GestureDetector(
        onTap: () {
          widget.onChange(dt, ViewType.VIEW_TYPE_WEEKLY);
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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

  Widget monthCreateDay(DateTime dt, int firstweek, int minutes) {
    Color fontColor = Colors.black;
    if ((dt.weekday == DateTime.saturday) || (dt.weekday == DateTime.sunday)) {
      fontColor = Colors.white;
    }
    return GestureDetector(
        onTap: () {
          widget.onChange(dt, ViewType.VIEW_TYPE_DAILY);
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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

  List createMonth(DateTime dateTime) {
    List monthItem = [];
    List weeksMinutes = List<int>.filled(5, 0);
    int firstWeek = widget.currentDate.firstDayOfTheMonthView.weekOfYear;

    DateTime dt = widget.currentDate.firstDayOfTheMonthView;
    DateTime dtNext = widget.currentDate.firstDayOfTheMonthView;
    DateTime dtweek = widget.currentDate.firstDayOfTheMonthView;

    for (int i = 0; i < 48; i++) {
      if ((i % 6) == 0) {
        monthItem.add(monthCreateDayOfWeek(i ~/ 6));
      } else {
        if (i >= 43) {
          monthItem
              .add(monthCreateWeekTotal(i, dtweek, firstWeek, weeksMinutes));
          dtweek = dtweek.add(Duration(days: 7));
        } else {
          int minutes = widget.workingSlotsList
              .perDate(dt.year, dt.month, dt.day)
              .sumMinutes();
          weeksMinutes[dt.weekOfYear - firstWeek] += minutes;
          monthItem.add(monthCreateDay(dt, firstWeek, minutes));
          if (((i + 1) % 6) == 0) {
            dtNext = dtNext.add(Duration(days: 1));
            dt = dtNext;
          } else {
            dt = dt.add(Duration(days: 7));
          }
        }
      }
    }
    return monthItem;
  }

  Widget getMonthly() {
    List _monthItem = [];
    _monthItem = createMonth(widget.currentDate);

    return GridView.count(
        primary: false,
        crossAxisCount: 6,
        childAspectRatio: (widget.width / 6) / (widget.height / 8),
        children: List.generate(48, (index) {
          return _montlyWorkingday(index, _monthItem);
        }));
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.viewType) {
      case ViewType.VIEW_TYPE_DAILY:
        return Container(
            height: widget.height, width: widget.width, child: getDaily());
      case ViewType.VIEW_TYPE_WEEKLY:
        return Container(
            height: widget.height, width: widget.width, child: getWeekly());
      case ViewType.VIEW_TYPE_MONTHLY:
        return Container(
            height: widget.height, width: widget.width, child: getMonthly());
      default:
        return Container(
            height: widget.height,
            width: widget.width,
            child: Text("Not implemented"));
    }
  }
}
