import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:timekeeperv2/utils/application.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:timekeeperv2/widget/context_footer.dart';
import 'package:timekeeperv2/widget/context_main.dart';
import 'package:timekeeperv2/widget/working_add.dart';
import 'package:timekeeperv2/widget/working_day.dart';
import 'package:timekeeperv2/business/working_slot.dart';
import 'package:timekeeperv2/widget/working_month.dart';
import 'package:timekeeperv2/widget/working_week.dart';

import 'widget/context_header.dart';

void main() {
  runApp(MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/daily',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/daily': (context) =>
            MyHomePage(title: "Daily", showWidget: WorkingDayWidget()),
        '/weekly': (context) =>
            MyHomePage(title: "Weekly", showWidget: WorkingWeekWidget()),
        '/monthly': (context) =>
            MyHomePage(title: "Monthly", showWidget: WorkingMonthlyWidget()),
        '/add': (context) =>
            MyHomePage(title: "Add", showWidget: WorkingAddWidget()),
        '/edit': (context) =>
            MyHomePage(title: "Edit", showWidget: WorkingAddWidget()),
      }));

  //runApp(const MyApp());
}

class ViewType {
  static const int VIEW_TYPE_DAILY = 1;
  static const int VIEW_TYPE_WEEKLY = 2;
  static const int VIEW_TYPE_MONTHLY = 4;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Time Keeper v2',
        showWidget: WorkingDayWidget(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.showWidget})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Widget showWidget;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _title = "Daily";

  bool _btnDailyVisible = false;
  bool _btnWeeklyVisible = true;
  bool _btnMonthlyVisible = true;

  DateTime _currentDate = DateTime.now();
  int _viewType = ViewType.VIEW_TYPE_DAILY;
  late WorkingSlotsList _wsList;

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
    _wsList = Application.instance
        .getWorkingSlotsList()
        .perDate(_currentDate.year, _currentDate.month, _currentDate.day);
  }

  void changeDate(DateTime dt) {
    _wsList.clear();
    switch (_viewType) {
      case ViewType.VIEW_TYPE_DAILY:
        _wsList = Application.instance
            .getWorkingSlotsList()
            .perDate(dt.year, dt.month, dt.day);
        _btnDailyVisible = false;
        _btnWeeklyVisible = true;
        _btnMonthlyVisible = true;
        _title = "Daily";
        break;
      case ViewType.VIEW_TYPE_WEEKLY:
        _wsList = Application.instance
            .getWorkingSlotsList()
            .perDateInterval(dt.firstDayOfTheWeek, dt.lastDayOfTheWeek);
        _btnDailyVisible = true;
        _btnWeeklyVisible = false;
        _btnMonthlyVisible = true;
        _title = "Weekly";
        break;
      case ViewType.VIEW_TYPE_MONTHLY:
        _wsList = Application.instance.getWorkingSlotsList().perDateInterval(
            dt.firstDayOfTheMonthView, dt.lastDayOfTheMonthView);
        _btnDailyVisible = true;
        _btnWeeklyVisible = true;
        _btnMonthlyVisible = false;
        _title = "Monthly";
        break;
    }
    setState(() {
      _currentDate = dt;
    });
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize();

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
                  workingSlotsList: _wsList,
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
                  workingSlotsList: _wsList,
                  onAdd: (ws) {
                    Navigator.pushNamed(context, "/add", arguments: ws)
                        .then((value) => ws.save());
                  },
                )),
          ],
        ));
  }
}
