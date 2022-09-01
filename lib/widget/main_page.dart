import 'package:flutter/material.dart';
import 'package:timekeeperv2/business/time_slot.dart';
import 'package:timekeeperv2/utils/application.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:timekeeperv2/widget/context_footer.dart';
import 'package:timekeeperv2/widget/context_main.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';
import 'base_app.dart';
import 'context_header.dart';
import 'base_page.dart';

class ViewType {
  static const int VIEW_TYPE_DAILY = 1;
  static const int VIEW_TYPE_WEEKLY = 2;
  static const int VIEW_TYPE_MONTHLY = 4;
}

class MainPage extends BasePage {
  const MainPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  BaseState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends BaseState<MainPage> {
  String _title = "XX";

  bool _btnDailyVisible = false;
  bool _btnWeeklyVisible = true;
  bool _btnMonthlyVisible = true;
  bool _btnAddVisible = true;

  DateTime _currentDate = DateTime.now();
  int _viewType = ViewType.VIEW_TYPE_DAILY;
  TimeSlotList _timeSlotList = TimeSlotHelper().emptyList;

  double _screenWidth = 0;
  double _screenHeight = 0;
  double _screenTopStatusBar = 0;
  double _screenBottomStatusBar = 0;

  double _screenToolsBar = 0;
  double _screenContextHeader = 0;
  double _screenContextFooter = 0;
  double _screenContextMain = 0;

  void initScreenSize() {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _screenTopStatusBar = MediaQuery.of(context).viewPadding.top;
    _screenBottomStatusBar = MediaQuery.of(context).viewPadding.bottom;

    _screenToolsBar = 60;
    _screenContextHeader = 100;
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

  @override
  void initState() {
    super.initState();

    //_timeSlotList = TimeSlotHelper()
    //.perDate(_currentDate.year, _currentDate.month, _currentDate.day);
  }

  void changeDate(DateTime dt) async {
    //_timeSlotList.clear();
    switch (_viewType) {
      case ViewType.VIEW_TYPE_DAILY:
        TimeSlotHelper().perDate(dt.year, dt.month, dt.day).then((value) {
          //setState(() {
          _timeSlotList = value;
          //});
        });
        _btnDailyVisible = false;
        _btnWeeklyVisible = true;
        _btnMonthlyVisible = true;
        _title = AppLocalizations.of(context)!.title_daily;
        break;
      case ViewType.VIEW_TYPE_WEEKLY:
        TimeSlotHelper()
            .perDateInterval(dt.firstDayOfTheWeek, dt.lastDayOfTheWeek)
            .then((value) {
          _timeSlotList = value;
        });
        _btnDailyVisible = true;
        _btnWeeklyVisible = false;
        _btnMonthlyVisible = true;
        _title = AppLocalizations.of(context)!.title_weekly;
        break;
      case ViewType.VIEW_TYPE_MONTHLY:
        TimeSlotHelper()
            .perDateInterval(
                dt.firstDayOfTheMonthView, dt.lastDayOfTheMonthView)
            .then((value) {
          _timeSlotList = value;
        });
        _btnDailyVisible = true;
        _btnWeeklyVisible = true;
        _btnMonthlyVisible = false;
        _title = AppLocalizations.of(context)!.title_monthly;
        break;
    }
    setState(() {
      _currentDate = dt;
    });
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize();
    changeDate(_currentDate);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: _screenToolsBar,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(_title),
          actions: [
            IconButton(
              onPressed: _btnDailyVisible
                  ? () {
                      _viewType = ViewType.VIEW_TYPE_DAILY;
                      changeDate(_currentDate);
                    }
                  : null,
              icon: const Icon(Icons.calendar_view_day_rounded),
            ),
            IconButton(
                onPressed: _btnWeeklyVisible
                    ? () {
                        _viewType = ViewType.VIEW_TYPE_WEEKLY;
                        changeDate(_currentDate);
                      }
                    : null,
                icon: const Icon(Icons.calendar_view_week_rounded)),
            IconButton(
                onPressed: _btnMonthlyVisible
                    ? () {
                        _viewType = ViewType.VIEW_TYPE_MONTHLY;
                        changeDate(_currentDate);
                      }
                    : null,
                icon: const Icon(Icons.calendar_view_month_rounded)),
            IconButton(
              onPressed: () {
                TimeSlot ws = TimeSlot.create(
                    _currentDate,
                    TimeOfDay(
                        hour: DateTime.now().hour, minute: DateTime.now().hour),
                    TimeOfDay(
                        hour: DateTime.now().add(Duration(hours: 1)).hour,
                        minute: DateTime.now().minute),
                    "");
                Navigator.pushNamed(context, ViewRoute.VIEW_ROUTE_ADD_EDIT,
                        arguments: ws)
                    .then((value) {
                  if (value as bool) {
                    ws.addInBox().then((value) => ws.save());
                    changeDate(ws.date);
                  }
                });
              },
              icon: const Icon(Icons.add_circle_outline_outlined),
            ),
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(AppLocalizations.of(context)!.menu_settings),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text(AppLocalizations.of(context)!.menu_export),
                ),
              ];
            }, onSelected: (value) {
              switch (value) {
                case 1: //Settings
                  //print("Settings menu is selected.");
                  Navigator.pushNamed(context, ViewRoute.VIEW_ROUTE_CONFIG,
                          arguments: null)
                      .then((value) {
                    ; /*
                    if ((value as bool) && (ws != null)) {
                      ws.save();
                      //Application.instance.getWorkingSlotsList().add(ws);
                      changeDate(ws.date);
                      }
                      */
                  });
                  break;
                case 2:
                  //print("Export menu is selected.");
                  Navigator.pushNamed(context, ViewRoute.VIEW_ROUTE_EXPORT,
                          arguments: null)
                      .then((value) {
                    ; /*
                    if ((value as bool) && (ws != null)) {
                      ws.save();
                      //Application.instance.getWorkingSlotsList().add(ws);
                      changeDate(ws.date);
                      }
                      */
                  });
                  break;
              }
            }),
          ],
        ),
        body: Column(
          children: [
            Container(
                height: _screenContextHeader,
                width: _screenWidth,
                color: Colors.blue,
                child: ContextHeaderWidget(
                  height: _screenContextHeader,
                  width: _screenWidth,
                  currentDate: _currentDate,
                  viewType: _viewType,
                  changeDate: (p0) {
                    changeDate(p0);
                  },
                )),
            Container(
                height: _screenContextMain,
                width: _screenWidth,
                color: Colors.grey,
                child: ContextMainWidget(
                  height: _screenContextMain,
                  width: _screenWidth,
                  currentDate: _currentDate,
                  viewType: _viewType,
                  onChange: (currentDate, type) {
                    _viewType = type;
                    changeDate(currentDate);
                  },
                  onEdit: (ws) {
                    Navigator.pushNamed(context, ViewRoute.VIEW_ROUTE_ADD_EDIT,
                            arguments: ws)
                        .then((value) {
                      if ((value as bool) && (ws != null)) {
                        ws.save();
                        //Application.instance.getWorkingSlotsList().add(ws);
                        changeDate(ws.date);
                      }
                    });
                  },
                  onDelete: (timeSlot) {
                    if (timeSlot != null) {
                      TimeSlotHelper()
                          .delete(timeSlot)
                          .then((value) => changeDate(timeSlot.date));
                    }
                  },
                  timeSlotList: _timeSlotList,
                )),
            Container(
                height: _screenContextFooter,
                width: _screenWidth,
                color: Colors.blue,
                child: ContextFooterWidget(
                  height: _screenContextFooter,
                  width: _screenWidth,
                  currentDate: _currentDate,
                  viewType: _viewType,
                  timeSlotList: _timeSlotList,
                  onAdd: (ws) {
                    Navigator.pushNamed(context, ViewRoute.VIEW_ROUTE_ADD_EDIT,
                            arguments: ws)
                        .then((value) {
                      if (value as bool) {
                        //Application.instance.getTimeSlotList().add(ws);

                        ws.addInBox().then((value) => ws.save());

                        changeDate(ws.date);
                      }
                    });
                  },
                )),
          ],
        ));
  }
}
