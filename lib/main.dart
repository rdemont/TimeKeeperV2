import 'package:flutter/material.dart';
import 'package:timekeeperv2/utils/application.dart';
import 'package:timekeeperv2/widget/working_add.dart';
import 'package:timekeeperv2/widget/working_day.dart';
import 'package:timekeeperv2/business/working_slot.dart';
import 'package:timekeeperv2/widget/working_month.dart';
import 'package:timekeeperv2/widget/working_week.dart';

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

bool btnDailyVisible = false;
bool btnWeeklyVisible = true;
bool btnMonthlyVisible = true;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: btnDailyVisible
                ? () {
                    setState(() {
                      btnDailyVisible = false;
                      btnWeeklyVisible = true;
                      btnMonthlyVisible = true;
                    });
                    Navigator.popAndPushNamed(context, '/daily');
                  }
                : null,
            icon: const Icon(Icons.calendar_view_day_rounded),
          ),
          IconButton(
              onPressed: btnWeeklyVisible
                  ? () {
                      setState(() {
                        btnDailyVisible = true;
                        btnWeeklyVisible = false;
                        btnMonthlyVisible = true;
                      });

                      Navigator.popAndPushNamed(context, '/weekly');
                    }
                  : null,
              icon: const Icon(Icons.calendar_view_week_rounded)),
          IconButton(
              onPressed: btnMonthlyVisible
                  ? () {
                      setState(() {
                        btnDailyVisible = true;
                        btnWeeklyVisible = true;
                        btnMonthlyVisible = false;
                      });

                      Navigator.popAndPushNamed(context, '/monthly');
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
      body: SingleChildScrollView(
          child: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[widget.showWidget],
        ),
      )),
      /*
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Start working "),
          Text("End working  "),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Add entry',
            child: const Icon(Icons.add),
          )
        ],
      ),
      bottomNavigationBar:
          BottomAppBar(color: Colors.blueAccent, child: Text("XXXX")),
          */
    );
  }
}
