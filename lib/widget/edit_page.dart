import 'package:flutter/material.dart';
import 'package:timekeeperv2/utils/application.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timekeeperv2/widget/base_page.dart';
import '../business/time_slot.dart';
import '../utils/time_of_day_extensions.dart';

import 'time_spinner_widget.dart';

import 'package:flutter_date_picker_timeline/flutter_date_picker_timeline.dart';

class EditPage extends BasePage {
  const EditPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  BaseState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends BaseState<EditPage> {
  String _title = "XX";
  bool _btnDailyVisible = false;
  bool _btnWeeklyVisible = false;
  bool _btnMonthlyVisible = false;

  double _screenWidth = 0;
  double _screenHeight = 0;
  double _screenTopStatusBar = 0;
  double _screenBottomStatusBar = 0;

  double _screenToolsBar = 0;
  double _screenContextHeader = 0;
  double _screenContextFooter = 0;
  double _screenContextMain = 0;

  TimeSlot _timeSlot = TimeSlot.createEmpty();

  void initScreenSize() {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _screenTopStatusBar = MediaQuery.of(context).viewPadding.top;
    _screenBottomStatusBar = MediaQuery.of(context).viewPadding.bottom;

    _screenToolsBar = 60;
    _screenContextHeader = 0; //100;
    _screenContextFooter = 80;
    _screenContextMain = _screenHeight -
        _screenTopStatusBar -
        _screenBottomStatusBar -
        _screenToolsBar -
        _screenContextHeader -
        _screenContextFooter;
  }

  Widget showSizeInfo() {
    return Column(
      children: [
        Text("_screenWidth: $_screenWidth\n"),
        Text("_screenHeight: $_screenHeight\n"),
        Text("_screenTopStatusBar: $_screenTopStatusBar\n"),
        Text("_screenBottomStatusBar: $_screenBottomStatusBar\n"),
        Text("_screenToolsBar: $_screenToolsBar\n"),
        Text("_screenContextHeader: $_screenContextHeader\n"),
        Text("_screenContextFooter: $_screenContextFooter\n"),
        Text("_screenContextMain: $_screenContextMain\n"),
      ],
    );
  }

  bool _isInited = false;
  int _minutesStep = 15;
  void initParameter() {
    if (!_isInited) {
      _isInited = true;
      final TimeSlot? args =
          ModalRoute.of(context)?.settings.arguments as TimeSlot?;
      if (args != null) {
        //setState(() {
        _timeSlot = args;
        //});

        changeDate();
      } else {
        Navigator.pop(context);
      }

      Application.instance.stepHour.then((value) {
        setState(() {
          _minutesStep = value;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  TimeSlotList _timeSlotList = TimeSlotHelper().emptyList;
  List<TimeSpinnerSlot> _hiddenSpotFrom = [];
  List<TimeSpinnerSlot> _hiddenSpotTo = [];

  void changeDate() async {
    TimeSlotHelper()
        .perDate(_timeSlot.date.year, _timeSlot.date.month, _timeSlot.date.day)
        .then((value) {
      setState(() {
        _timeSlotList = value;
        List<TimeSpinnerSlot> result = [];
        result.clear();
        for (int i = 0; i < _timeSlotList.length; i++) {
          if (_timeSlotList[i]!.id != _timeSlot.id) {
            result.add(TimeSpinnerSlot(_timeSlotList[i]!.startTime,
                _timeSlotList[i]!.endTime ?? _timeSlotList[i]!.startTime));
          }
        }
        _hiddenSpotFrom = result;
      });
    });
  }

  void hiddenSpotFrom() {
    List<TimeSpinnerSlot> result = [];
    result.clear();
    for (int i = 0; i < _timeSlotList.length; i++) {
      if (_timeSlotList[i]!.id != _timeSlot.id) {
        result.add(TimeSpinnerSlot(_timeSlotList[i]!.startTime,
            _timeSlotList[i]!.endTime ?? _timeSlotList[i]!.startTime));
      }
    }
    setState(() {
      _hiddenSpotFrom = result;
    });
  }

  void hiddenSpotTo(TimeOfDay from) {
    List<TimeSpinnerSlot> result = [];
    result.clear();
    result.add(TimeSpinnerSlot(TimeOfDay(hour: 0, minute: 0), from));
    for (int i = 0; i < _timeSlotList.length; i++) {
      if (_timeSlotList[i]!.id != _timeSlot.id) {
        if (_timeSlotList[i]!.startTime.isAfter(from)) {
          result.add(TimeSpinnerSlot(
              _timeSlotList[i]!.startTime, TimeOfDay(hour: 23, minute: 59)));
        }
      }
    }
    setState(() {
      _hiddenSpotTo = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    Key keyFrom = UniqueKey();
    Key keyTo = UniqueKey();
    initScreenSize();
    initParameter();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: _screenToolsBar,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(_title),
          actions: [
            IconButton(
              onPressed: _btnDailyVisible ? () {} : null,
              icon: const Icon(Icons.calendar_view_day_rounded),
            ),
            IconButton(
                onPressed: _btnWeeklyVisible ? () {} : null,
                icon: const Icon(Icons.calendar_view_week_rounded)),
            IconButton(
                onPressed: _btnMonthlyVisible ? () {} : null,
                icon: const Icon(Icons.calendar_view_month_rounded)),
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("My Account"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Settings"),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text("Logout"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                print("My account menu is selected.");
              } else if (value == 1) {
                print("Settings menu is selected.");
              } else if (value == 2) {
                print("Logout menu is selected.");
              }
            }),
          ],
        ),
        body: Column(
          children: [
            Container(
                height: _screenContextMain,
                width: _screenWidth,
                color: Colors.grey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(children: [
                    FlutterDatePickerTimeline(
                      startDate: DateTime.now().add(Duration(days: -100)),
                      endDate: DateTime.now().add(Duration(days: 100)),
                      initialSelectedDate: _timeSlot.date,
                      onSelectedDateChange: (dateTime) {
                        if ((dateTime != null) &&
                            !(dateTime.isSameDateAs(_timeSlot.date))) {
                          _timeSlot.date = dateTime;
                          changeDate();
                          //_timeSlotList = TimeSlotHelper().perDate(_timeSlot.date.year,_timeSlot.date.month, _timeSlot.date.day);
                          hiddenSpotFrom();
                        }
                      },
                    ),
                    Container(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Column(children: [
                        Text("From: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white)),
                        Container(
                          height: 10,
                        ),
                        TimeSpinnerWidget(
                          key: keyFrom,
                          minimumTime: TimeOfDay(hour: 0, minute: 0),
                          maximumTime: TimeOfDay(hour: 23, minute: 0),
                          use24hFormat: true,
                          selectedValue: _timeSlot.startTime,
                          hiddenSlot: _hiddenSpotFrom,
                          minutesStep: _minutesStep,
                          onSetTime: (value) {
                            _timeSlot.startTime = value;
                            hiddenSpotTo(value);
                            PageStorage.of(context)!.writeState(
                              context,
                              _hiddenSpotTo,
                              identifier: keyTo,
                            );
                          },
                        ),
                      ]),
                      Container(
                        width: 20,
                      ),
                      Column(children: [
                        Text("To : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white)),
                        Container(
                          height: 10,
                        ),
                        TimeSpinnerWidget(
                          key: keyTo,
                          minimumTime: TimeOfDay(hour: 0, minute: 0),
                          maximumTime: TimeOfDay(hour: 23, minute: 59),
                          use24hFormat: true,
                          minutesStep: _minutesStep,
                          selectedValue:
                              _timeSlot.endTime ?? _timeSlot.startTime,
                          hiddenSlot: _hiddenSpotTo,
                          onSetTime: (value) {
                            _timeSlot.endTime = value;
                          },
                        ),
                      ]),
                    ])
                  ]),
                )),
            Container(
                height: _screenContextFooter,
                width: _screenWidth,
                color: Colors.blue,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text("SAVE ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white)))),
          ],
        ));
  }
}
