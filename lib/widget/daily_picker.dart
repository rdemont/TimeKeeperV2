library daily_picker;

import 'package:flutter/material.dart';
import 'package:timekeeperv2/utils/application.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:week_of_year/week_of_year.dart';
//import "package:weekly_date_picker/datetime_apis.dart";

class DailyPicker extends StatefulWidget {
  DailyPicker({
    Key? key,
    required this.selectedDay,
    required this.changeDay,
    this.weekdayText = 'Week',
    this.weekdays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.selectedBackgroundColor = const Color(0xFF2A2859),
    this.selectedDigitColor = const Color(0xFFFFFFFF),
    this.digitsColor = const Color(0xFF000000),
    this.weekdayTextColor = const Color(0xFF303030),
    this.enableWeeknumberText = true,
    this.weeknumberColor = const Color(0xFFB2F5FE),
    this.weeknumberTextColor = const Color(0xFF000000),
    this.daysInWeek = 7,
  })  : assert(weekdays.length == daysInWeek,
            "weekdays must be of length $daysInWeek"),
        super(key: key);

  /// The current selected day
  final DateTime selectedDay;

  /// Callback function with the new selected date
  final Function(DateTime) changeDay;

  /// Specifies the weekday text: default is 'Week'
  final String weekdayText;

  /// Specifies the weekday strings ['Mon', 'Tue'...]
  final List<String> weekdays;

  /// Background color
  final Color backgroundColor;

  /// Color of the selected digits text
  final Color selectedBackgroundColor;

  /// Color of the unselected digits text
  final Color selectedDigitColor;

  /// Color of the unselected digits text
  final Color digitsColor;

  /// Is the color of the weekdays 'Mon', 'Tue'...
  final Color weekdayTextColor;

  /// Set to false to hide the weeknumber textfield to the left of the slider
  final bool enableWeeknumberText;

  /// Color of the weekday container
  final Color weeknumberColor;

  /// Color of the weekday text
  final Color weeknumberTextColor;

  /// Specifies the number of weekdays to render, default is 7, so Monday to Sunday
  final int daysInWeek;

  @override
  _DailyPickerState createState() => _DailyPickerState();
}

class _DailyPickerState extends State<DailyPicker> {
  final DateTime _todaysDateTime = DateTime.now();

  // About 100 years back in time should be sufficient for most users, 52 weeks * 100
  final int _weekIndexOffset = 5200;

  late final PageController _controller;
  late final DateTime _initialSelectedDay;
  late int _weeknumberInSwipe;
  late int _yearnumberInSwipe;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _weekIndexOffset);
    _initialSelectedDay = widget.selectedDay;
    _weeknumberInSwipe = widget.selectedDay.weekOfYear;
    _yearnumberInSwipe = widget.selectedDay.year;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      color: widget.backgroundColor,
      child: Row(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: 2,
              ),
              (widget.enableWeeknumberText
                  ? Container(
                      padding: EdgeInsets.all(8.0),
                      color: widget.weeknumberColor,
                      child: Text(
                        '${widget.weekdayText} $_weeknumberInSwipe\n  $_yearnumberInSwipe',
                        style: TextStyle(color: widget.weeknumberTextColor),
                      ),
                    )
                  : Container()),
              Container(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.animateToPage(_weekIndexOffset,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);

                      //Application.instance.setCurrentDate(DateTime.now());
                      widget.changeDay(DateTime.now());
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.today,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (int index) {
                setState(() {
                  _weeknumberInSwipe = _initialSelectedDay
                      .add(Duration(days: 7 * (index - _weekIndexOffset)))
                      .weekOfYear;
                  _yearnumberInSwipe = _initialSelectedDay
                      .add(Duration(days: 7 * (index - _weekIndexOffset)))
                      .year;
                });
              },
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, weekIndex) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _weekdays(weekIndex - _weekIndexOffset),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builds a X day list of DateButtons
  List<Widget> _weekdays(int weekIndex) {
    List<Widget> weekdays = [];

    for (int i = 0; i < widget.daysInWeek; i++) {
      final int offset = i + 1 - _initialSelectedDay.weekday;
      final int daysToAdd = weekIndex * 7 + offset;
      final DateTime dateTime =
          _initialSelectedDay.add(Duration(days: daysToAdd));
      weekdays.add(_dateButton(dateTime));
    }
    return weekdays;
  }

  Widget _dateButton(DateTime dateTime) {
    final String weekday = widget.weekdays[dateTime.weekday - 1];
    final bool isSelected = dateTime.isSameDateAs(widget.selectedDay);

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.changeDay(dateTime),
        child: Container(
          // Bugfix, the transparent container makes the GestureDetector fill the Expanded
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  '$weekday',
                  style:
                      TextStyle(fontSize: 12.0, color: widget.weekdayTextColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                    // Border around today's date
                    color: dateTime.isSameDateAs(_todaysDateTime)
                        ? widget.selectedBackgroundColor
                        : Colors.transparent,
                    shape: BoxShape.circle),
                child: CircleAvatar(
                  backgroundColor: isSelected
                      ? widget.selectedBackgroundColor
                      : widget.backgroundColor,
                  radius: 14.0,
                  child: Text(
                    '${dateTime.day}',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: isSelected
                            ? widget.selectedDigitColor
                            : widget.digitsColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
