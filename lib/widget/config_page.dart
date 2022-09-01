import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:timekeeperv2/utils/application.dart';
import 'package:timekeeperv2/widget/base_page.dart';

import '../utils/utils.dart';
import 'title_box_widget.dart';

class ConfigPage extends BasePage {
  const ConfigPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  BaseState<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends BaseState<ConfigPage> {
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

  double _columnLeft = 200;

  void initScreenSize() {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _screenTopStatusBar = MediaQuery.of(context).viewPadding.top;
    _screenBottomStatusBar = MediaQuery.of(context).viewPadding.bottom;

    _screenToolsBar = 60;
    _screenContextHeader = 0;
    _screenContextFooter = 0;
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
    //_title = AppLocalizations.of(context)!.title_settings;
  }

  int _stepHour = 15;
  void setStepHour(int stepHour) {
    if (_stepHour != stepHour) {
      setState(() {
        _stepHour = stepHour;
      });
      Application.instance.setStepHour(_stepHour);
    }
  }

  bool _isMonday = true;
  bool _isTuesday = true;
  bool _isWednesday = true;
  bool _isThursday = true;
  bool _isFriday = true;
  bool _isSaterday = true;
  bool _isSunday = true;
  void setWorkingDays() {
    Application.instance.setWorkingDays(_isMonday, _isTuesday, _isWednesday,
        _isThursday, _isFriday, _isSaterday, _isSunday);
  }

  void loadData() {
    Application.instance.stepHour.then((value) {
      if (value != _stepHour) {
        setState(() {
          _stepHour = value;
        });
      }
    });

    Application.instance.hourPerDay.then((value) {
      if (value != _hourPerDay) {
        setState(() {
          _hourPerDay = value;
        });
      }
    });

    Application.instance.workingDayMonday.then((value) {
      if (_isMonday != value) {
        setState(() {
          _isMonday = value;
        });
      }
    });
    Application.instance.workingDayTuesday.then((value) {
      if (_isTuesday != value) {
        setState(() {
          _isTuesday = value;
        });
      }
    });
    Application.instance.workingDayWedesday.then((value) {
      if (_isWednesday != value) {
        setState(() {
          _isWednesday = value;
        });
      }
    });
    Application.instance.workingDayThursday.then((value) {
      if (_isThursday != value) {
        setState(() {
          _isThursday = value;
        });
      }
    });
    Application.instance.workingDayFriday.then((value) {
      if (_isFriday != value) {
        setState(() {
          _isFriday = value;
        });
      }
    });
    Application.instance.workingDaySaterday.then((value) {
      if (_isSaterday != value) {
        setState(() {
          _isSaterday = value;
        });
      }
    });
    Application.instance.workingDaySunday.then((value) {
      if (_isSunday != value) {
        setState(() {
          _isSunday = value;
        });
      }
    });
  }

  double _hourPerDay = 0.0;
  setHourPerDay(String value) {
    //double result = 0.0;
    if (timeFormater.type == TimeFormatter.TIME_FORMATTER_HOURMINUTES) {
      int hour = int.tryParse(value.substring(0, value.indexOf(":"))) ?? 0;
      int minutes = int.tryParse(value.substring(value.indexOf(":") + 1)) ?? 0;

      _hourPerDay = double.tryParse(hour.toString() + ".0") ?? 0.0;
      _hourPerDay += (minutes / 60);
      _hourPerDay = ((_hourPerDay * 100).toInt() / 100);
    } else {
      _hourPerDay = double.tryParse(value.replaceAll(",", ".")) ?? 0.0;
    }
    Application.instance.setHourPerDay(_hourPerDay);
  }

  TimeFormatter timeFormater =
      TimeFormatter(TimeFormatter.TIME_FORMATTER_HOURMINUTES);

  @override
  Widget build(BuildContext context) {
    initScreenSize();
    loadData();
    _title = AppLocalizations.of(context)!.title_settings;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: _screenToolsBar,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(_title),
        ),
        body: Column(
          children: [
            Container(
                height: _screenContextHeader,
                width: _screenWidth,
                color: Colors.blue,
                child: Text("Top")),
            Container(
                height: _screenContextMain,
                width: _screenWidth,
                color: Colors.grey,
                child: Column(children: [
                  TitleBox(
                      onClickHelp: (p0) {},
                      title: "Working days",
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        color: Colors.white,
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ActionChip(
                                  backgroundColor:
                                      _isMonday ? Colors.blue : Colors.grey,
                                  label: Text(AppLocalizations.of(context)!
                                      .monday_short),
                                  onPressed: () {
                                    setState(() {
                                      _isMonday = !_isMonday;
                                    });
                                    setWorkingDays();
                                  },
                                ),
                                SizedBox(width: 10),
                                ActionChip(
                                  backgroundColor:
                                      _isTuesday ? Colors.blue : Colors.grey,
                                  label: Text(AppLocalizations.of(context)!
                                      .tuesday_short),
                                  onPressed: () {
                                    setState(() {
                                      _isTuesday = !_isTuesday;
                                    });
                                    setWorkingDays();
                                  },
                                ),
                                SizedBox(width: 10),
                                ActionChip(
                                  backgroundColor:
                                      _isWednesday ? Colors.blue : Colors.grey,
                                  label: Text(AppLocalizations.of(context)!
                                      .wednesday_short),
                                  onPressed: () {
                                    setState(() {
                                      _isWednesday = !_isWednesday;
                                    });
                                    setWorkingDays();
                                  },
                                ),
                                SizedBox(width: 10),
                                ActionChip(
                                  backgroundColor:
                                      _isThursday ? Colors.blue : Colors.grey,
                                  label: Text(AppLocalizations.of(context)!
                                      .thursday_short),
                                  onPressed: () {
                                    setState(() {
                                      _isThursday = !_isThursday;
                                    });
                                    setWorkingDays();
                                  },
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ActionChip(
                                  backgroundColor:
                                      _isFriday ? Colors.blue : Colors.grey,
                                  label: Text(AppLocalizations.of(context)!
                                      .friday_short),
                                  onPressed: () {
                                    setState(() {
                                      _isFriday = !_isFriday;
                                    });
                                    setWorkingDays();
                                  },
                                ),
                                SizedBox(width: 10),
                                ActionChip(
                                  backgroundColor:
                                      _isSaterday ? Colors.blue : Colors.grey,
                                  label: Text(AppLocalizations.of(context)!
                                      .saturday_short),
                                  onPressed: () {
                                    setState(() {
                                      _isSaterday = !_isSaterday;
                                    });
                                    setWorkingDays();
                                  },
                                ),
                                SizedBox(width: 10),
                                ActionChip(
                                  backgroundColor:
                                      _isSunday ? Colors.blue : Colors.grey,
                                  label: Text(AppLocalizations.of(context)!
                                      .sunday_short),
                                  onPressed: () {
                                    setState(() {
                                      _isSunday = !_isSunday;
                                    });
                                    setWorkingDays();
                                  },
                                ),
                              ])
                        ]),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TitleBox(
                    title: "Hour per day",
                    onClickHelp: (p0) {},
                    child: Container(
                        child: Row(children: [
                      Expanded(
                          child: TextField(
                              controller: TextEditingController()
                                ..text =
                                    timeFormater.getStringValue(_hourPerDay),
                              onSubmitted: (value) {
                                setHourPerDay(value as String);
                              },
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                  hintText: timeFormater.getTemplate()),
                              inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                timeFormater.getRegex())
                          ])),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: DropdownButton(
                        icon: Icon(Icons.merge_type_outlined),
                        value: timeFormater.type,
                        items: const [
                          DropdownMenuItem(
                              value: TimeFormatter.TIME_FORMATTER_HOURMINUTES,
                              child: Text("HH:MM")),
                          DropdownMenuItem(
                              value: TimeFormatter.TIME_FORMATTER_DECIMAL,
                              child: Text("Decimal"))
                        ],
                        onChanged: (value) {
                          setState(() {
                            timeFormater.type = value as int;
                          });
                        },
                      ))
                    ])),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TitleBox(
                      title: "Time step",
                      onClickHelp: (p0) {},
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          width: _screenWidth,
                          color: Colors.white,
                          child: Center(
                              child: DropdownButton(
                            icon: Icon(Icons.view_timeline_rounded),
                            items: const [
                              DropdownMenuItem(
                                value: 1,
                                child: Text('1 Minutes'),
                              ),
                              DropdownMenuItem(
                                value: 5,
                                child: Text("5 Minutes"),
                              ),
                              DropdownMenuItem(
                                value: 10,
                                child: Text("10 Minutes"),
                              ),
                              DropdownMenuItem(
                                value: 15,
                                child: Text("15 Minutes"),
                              ),
                              DropdownMenuItem(
                                value: 30,
                                child: Text("30 Minutes"),
                              ),
                              DropdownMenuItem(
                                value: 60,
                                child: Text("1 heure"),
                              ),
                            ],
                            onChanged: (v) {
                              setStepHour(v as int);
                            },
                            value: _stepHour,
                          )))),
                  SizedBox(
                    height: 10,
                  ),
                  TitleBox(
                      title: "Language",
                      onClickHelp: (p0) {},
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          width: _screenWidth,
                          color: Colors.white,
                          child: Center(
                              child: DropdownButton(
                            icon: Icon(Icons.language),
                            items: const [
                              DropdownMenuItem(
                                value: Locale('en'),
                                child: Text('English'),
                              ),
                              DropdownMenuItem(
                                value: Locale('fr'),
                                child: Text("Français"),
                              ),
                            ],
                            onChanged: (v) => setState(() {
                              setLocale(v as Locale);
                            }),
                            value: getLocale(),
                          )))),
                ])),
            Container(
                height: _screenContextFooter,
                width: _screenWidth,
                color: Colors.blue,
                child: Text("Footer")),
          ],
        ));
  }
}

class TimeFormatter extends TextInputFormatter {
  static const int TIME_FORMATTER_HOURMINUTES = 1;
  static const int TIME_FORMATTER_DECIMAL = 2;

  int _type = TIME_FORMATTER_HOURMINUTES;
  int get type {
    return _type;
  }

  set type(int type) {
    _type = type;
  }

  RegExp REG_HOURMINUTES = RegExp(r'^(?:[01]?\d|2[0-3])(?::(?:[0-5]\d?)?)?$');
  //RegExp(r'^(?:[01]?[0-9]|2[0-3])(?::(?:[0-5]\d?)?)?$');
  RegExp REG_DECIMAL =
      RegExp(r'^(?:[01]?[0-9]|2[0-3])(?:[,|.](?:[0-9][0-9]?)?)?$');

  String TEMPLATE_HOURMINUTES = "00:00";
  String TEMPLATE_DECIMAL = "00,00";

  TimeFormatter(int type) {
    _type = type;
  }

  RegExp getRegex() {
    switch (_type) {
      case TimeFormatter.TIME_FORMATTER_DECIMAL:
        return REG_DECIMAL;
      case TimeFormatter.TIME_FORMATTER_HOURMINUTES:
        return REG_HOURMINUTES;
    }
    return RegExp("");
  }

  String getTemplate() {
    switch (_type) {
      case TimeFormatter.TIME_FORMATTER_DECIMAL:
        return TEMPLATE_DECIMAL;
      case TimeFormatter.TIME_FORMATTER_HOURMINUTES:
        return TEMPLATE_HOURMINUTES;
    }
    return "";
  }

  String getStringValue(double value) {
    String result;
    switch (_type) {
      case TimeFormatter.TIME_FORMATTER_DECIMAL:
        return value.toStringAsFixed(2);
      case TimeFormatter.TIME_FORMATTER_HOURMINUTES:
        return Utils.instance.NumberFormat("0", 2, value.toInt()) +
            ":" +
            Utils.instance
                .NumberFormat("0", 2, ((value - value.toInt()) * 60).toInt());
    }
    return "";
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    //if (newValue.text.isEmpty) {
    return oldValue; //TextEditingValue(text: "00:00");
//    }
  }
}
