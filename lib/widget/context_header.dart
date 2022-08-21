import 'package:flutter/material.dart';
//import 'package:timekeeperv2/main.dart';
import '../utils/date_extensions.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/utils.dart';
import 'daily_picker.dart';
import 'main_page.dart';

class ContextHeaderWidget extends StatefulWidget {
  ContextHeaderWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.currentDate,
    required this.viewType,
    required this.changeDate,
  }) : super(key: key);

  final double height;
  final double width;
  DateTime currentDate;
  int viewType;
  final Function(DateTime) changeDate;
  @override
  _ContextHeaderWidget createState() => _ContextHeaderWidget();
}

class _ContextHeaderWidget extends State<ContextHeaderWidget> {
  _ContextHeaderWidget();

  Widget getDaily() {
    return DailyPicker(
        selectedDay: widget.currentDate,
        changeDay: (value) {
          setState(() {
            widget.changeDate(value);
          });
        },
        weekdayText: AppLocalizations.of(context)!.week,
        enableWeeknumberText: true,
        weeknumberColor: Colors.blue,
        weeknumberTextColor: Colors.white,
        backgroundColor: Colors.blue,
        weekdayTextColor: Colors.white,
        digitsColor: Colors.white,
        selectedBackgroundColor: Colors.white,
        selectedDigitColor: Colors.black,
        weekdays: [
          AppLocalizations.of(context)!.monday_short,
          AppLocalizations.of(context)!.tuesday_short,
          AppLocalizations.of(context)!.wednesday_short,
          AppLocalizations.of(context)!.thursday_short,
          AppLocalizations.of(context)!.friday_short,
          AppLocalizations.of(context)!.saturday_short,
          AppLocalizations.of(context)!.sunday_short
        ],
        daysInWeek: 7);
  }

  String _weekFromToFactory(DateTime dt) {
    return dt.firstDayOfTheWeek.formated("dd.MM.yyyy") +
        " - " +
        dt.lastDayOfTheWeek.formated("dd.MM.yyyy");
  }

  Widget getWeekly() {
    int _weekNumber = widget.currentDate.weekOfYear;
    int _yearNumber = widget.currentDate.year;
    String _weekFromTo = _weekFromToFactory(widget.currentDate);

    return Dismissible(
        key: Key("${_weekFromTo}"),
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          setState(() {
            //print(direction == DismissDirection.endToStart ? "1" : "-1");
            if (direction == DismissDirection.endToStart) {
              widget.currentDate = widget.currentDate.add(Duration(days: 7));
              widget.changeDate(widget.currentDate);
            } else {
              widget.currentDate = widget.currentDate.add(Duration(days: -7));
              widget.changeDate(widget.currentDate);
            }
          });
        },
        child: Row(
          children: [
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                onPressed: () {
                  setState(() {
                    widget.changeDate(DateTime.now());
                  });
                },
                child: Container(
                  width: 70,
                  child: Text(AppLocalizations.of(context)!.today,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white)),
                )),
            Container(
              width: 20,
            ),
            Column(
              children: [
                Container(
                  height: 10,
                ),
                Text(
                    "${AppLocalizations.of(context)!.week_short} $_weekNumber / $_yearNumber",
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
        ));
  }

  Widget getMonthly() {
    String _monthTitle = "${Utils.instance.MonthName(widget.currentDate)} ";
    String _yearTitle = "${widget.currentDate.year}";
    return Dismissible(
        key: Key("${_monthTitle}"),
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          setState(() {
            //print(direction == DismissDirection.endToStart ? "1" : "-1");
            if (direction == DismissDirection.endToStart) {
              widget.currentDate = DateTime(widget.currentDate.year,
                  widget.currentDate.month + 1, widget.currentDate.day);
              widget.changeDate(widget.currentDate);
            } else {
              widget.currentDate = DateTime(widget.currentDate.year,
                  widget.currentDate.month - 1, widget.currentDate.day);
              widget.changeDate(widget.currentDate);
            }
          });
        },
        child: Row(
          children: [
            Container(
                width: 100,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.changeDate(DateTime.now());
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.today,
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
                    Text(_yearTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white)),
                    Text(_monthTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white)),
                  ],
                ))
          ],
        ));
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
