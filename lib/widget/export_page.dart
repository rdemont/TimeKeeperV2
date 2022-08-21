import 'package:flutter/material.dart';

import 'package:timekeeperv2/utils/application.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:timekeeperv2/utils/utils.dart';
import 'package:timekeeperv2/widget/base_page.dart';
import 'package:timekeeperv2/widget/dropdown_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import '../business/time_slot.dart';

class ExportPage extends BasePage {
  const ExportPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  BaseState<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends BaseState<ExportPage> {
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
    DateTime dt = DateTime.now()
        .firstDayOfTheMonth
        .add(Duration(days: -1))
        .firstDayOfTheMonth;
    //_ddMonthValue = dt.formated("yyyyMM");
    changeDate(dt);
  }

  int _currentIndex = 1;
  List<DropdownMenuItem<String>> _ddMonth = [];
  void initDropDownList() {
    _ddMonth.clear();
    DateTime dt = DateTime.now().firstDayOfTheMonth;
    for (int i = 0; i < 13; i++) {
      _ddMonth.add(DropdownMenuItem(
        value: dt.formated("yyyyMM"),
        child: Text("${dt.MonthName(context)} ${dt.formated("yyyy")}"),
      ));
      dt = dt.add(Duration(days: -1)).firstDayOfTheMonth;
    }

    //_ddMonthValue = _ddMonth[1].value ?? "";
  }

  void _onShare(BuildContext context, String text, String subject) async {
    final box = context.findRenderObject() as RenderBox?;

    if (text.length == 0) {
      text = subject;
    }

    await Share.share(text,
        subject: subject,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  late TimeSlotList _timeSlotList;
  void changeDate(DateTime dt) async {
    TimeSlotHelper().perYearMonth(dt.year, dt.month).then((value) {
      setState(() {
        _timeSlotList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize();
    initDropDownList();
    double _width = _screenWidth;
    _title = AppLocalizations.of(context)!.title_export;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: _screenToolsBar,
          title: Text(_title),
        ),
        body: Column(
          children: [
            Container(
                height: _screenContextMain,
                width: _screenWidth,
                color: Colors.grey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        width: _width,
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                        child: Text('Which month you want to export',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black)),
                      ),
                      Container(
                          color: Colors.white,
                          width: _width,
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: DropDownWidget(
                            items: _ddMonth,
                            defaultIndex: _currentIndex,
                            onChange: (index) {
                              setState(() {
                                DateTime dt = DateTime(
                                    int.parse(
                                        _ddMonth[index].value!.substring(0, 4)),
                                    int.parse(
                                        _ddMonth[index].value!.substring(4, 6)),
                                    1);
                                changeDate(dt);
                                _currentIndex = index;
                              });
                            },
                          )),
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                          width: _width,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue.shade900,
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                  onPressed: () {
                                    _onShare(context, _timeSlotList.csv(),
                                        "${_ddMonth[_currentIndex]} CSV");
                                    //print("Export");
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.export,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white))))),
                      Container(height: 10),
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          width: _width,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue.shade900,
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                  onPressed: () {
                                    TimeSlotHelper().allRecord().then((value) {
                                      _onShare(context, value.csv(),
                                          "${AppLocalizations.of(context)!.export_all} CSV");
                                    });
                                    //print("Export");
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.export_all,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white))))),
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
