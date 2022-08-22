import 'package:flutter/material.dart';

import 'package:timekeeperv2/main.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timekeeperv2/widget/base_page.dart';

import '../business/time_slot.dart';
import '../utils/utils.dart';
import 'daily_picker.dart';
import 'main_page.dart';

class ContextMainWidget extends BasePage {
  ContextMainWidget(
      {Key? key,
      required this.height,
      required this.width,
      required this.currentDate,
      required this.viewType,
      required this.onChange,
      required this.onEdit,
      required this.onDelete,
      required this.timeSlotList})
      : super(key: key);

  final double height;
  final double width;
  DateTime currentDate;
  TimeSlotList timeSlotList;
  int viewType;
  final Function(DateTime currentDate, int type) onChange;
  final Function(TimeSlot? timeSlot) onEdit;
  final Function(TimeSlot? timeSlot) onDelete;

  @override
  _ContextMainWidget createState() => _ContextMainWidget();
}

class _ContextMainWidget extends State<ContextMainWidget> {
  _ContextMainWidget();

  Widget getDaily() {
    return ListView.builder(
        itemCount: widget.timeSlotList.length,
        itemBuilder: (BuildContext, index) {
          return Slidable(
              closeOnScroll: true,
              groupTag: "TAG0",
              endActionPane: ActionPane(motion: ScrollMotion(), children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 2,
                  onPressed: (context) {
                    widget.onEdit(widget.timeSlotList[index]);
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
                              title: Text(AppLocalizations.of(context)!
                                  .title_box_delete),
                              content: Text(AppLocalizations.of(context)!
                                  .message_box_delete),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    widget.onDelete(widget.timeSlotList[index]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    color: Colors.grey,
                                    padding: const EdgeInsets.all(14),
                                    child:
                                        Text(AppLocalizations.of(context)!.ok),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    color: Colors.grey,
                                    padding: const EdgeInsets.all(14),
                                    child: Text(
                                        AppLocalizations.of(context)!.cancel),
                                  ),
                                ),
                              ],
                            ));
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: AppLocalizations.of(context)!.delete,
                ),
              ]),
              child: Card(
                  child: ListTile(
                title: Row(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${AppLocalizations.of(context)!.from} : "),
                      Text("${AppLocalizations.of(context)!.to} : "),
                    ],
                  ),
                  Column(children: [
                    Text(Utils.instance
                        .longHour(widget.timeSlotList[index]!.startTime)),
                    Text(Utils.instance
                        .longHour(widget.timeSlotList[index]!.endTime)),
                  ]),
                  Container(
                    width: 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          "${AppLocalizations.of(context)!.total_in_minutes} : "),
                      Text(
                          "${AppLocalizations.of(context)!.total_in_decimals} : "),
                    ],
                  ),
                  Column(
                    children: [
                      Text(Utils.instance.humainReadableMinutesPerHour(
                          widget.timeSlotList[index]!.minutes)),
                      Text(Utils.instance.humainReadableDecimalPerHour(
                          widget.timeSlotList[index]!.minutes))
                    ],
                  ),
                ]),
                subtitle: Text(widget.timeSlotList[index]!.description ?? ""),
              )));
        });
  }

  Widget createDayOfTheWeek(DateTime dt) {
    Color bgColor = Colors.white;
    //int totMinutes = 0;
    int dayMinutes = 0;
    if ((dt.weekday == DateTime.saturday) || (dt.weekday == DateTime.sunday)) {
      bgColor = Colors.grey;
    }

    //TimeSlotList timeSlotList =widget.timeSlotList.perDate(dt.year, dt.month, dt.day);
    dayMinutes = widget.timeSlotList.minutesForDay(dt); //timeSlotList.minutes;
    //totMinutes += dayMinutes ;
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
              Text("${dt.dayName(context)} ${dt.day} ${dt.formated("MMMM")} ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dayMinutes > 0
                      ? "${AppLocalizations.of(context)!.hours_minutes_long} : "
                      : ""),
                  Text(
                      "${Utils.instance.humainReadableMinutesPerHour(dayMinutes)}")
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(dayMinutes > 0
                    ? "${AppLocalizations.of(context)!.hours_decimals_long} : "
                    : ""),
                Text(
                    "${Utils.instance.humainReadableDecimalPerHour(dayMinutes)}")
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
        str = AppLocalizations.of(context)!.monday_short;
        break;
      case 1:
        str = AppLocalizations.of(context)!.tuesday_short;
        break;
      case 2:
        str = AppLocalizations.of(context)!.wednesday_short;
        break;
      case 3:
        str = AppLocalizations.of(context)!.thursday_short;
        break;
      case 4:
        str = AppLocalizations.of(context)!.friday_short;
        break;
      case 5:
        str = AppLocalizations.of(context)!.saturday_short;
        fontColor = Colors.white;
        break;
      case 6:
        str = AppLocalizations.of(context)!.sunday_short;
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
    int weekIndex = dt.weekOfYear - firstWeek;
    if (weekIndex < 0) {
      weekIndex = firstWeek + dt.weekOfYear - 52;
    }
    int minutes = weekMinutes[weekIndex];
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
                  "${AppLocalizations.of(context)!.week_short} ${dt.weekOfYear}",
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
    //int weekInMonth = 0;
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
          int minutes = widget.timeSlotList.minutesForDay(dt);

          //    widget.timeSlotList.perDate(dt.year, dt.month, dt.day).minutes;
          int weekIndex = dt.weekOfYear - firstWeek;
          if (weekIndex < 0) {
            weekIndex = firstWeek + dt.weekOfYear - 52;
          }

          weeksMinutes[weekIndex] += minutes;
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
