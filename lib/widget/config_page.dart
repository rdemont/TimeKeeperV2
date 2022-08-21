import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timekeeperv2/widget/base_page.dart';

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

  @override
  Widget build(BuildContext context) {
    initScreenSize();
    _title = AppLocalizations.of(context)!.title_settings;
    return Scaffold(
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
              child: Center(
                  child: DropdownButton(
                icon: Icon(Icons.language),
                items: [
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
              )),
            ),
            Container(
                height: _screenContextFooter,
                width: _screenWidth,
                color: Colors.blue,
                child: Text("Footer")),
          ],
        ));
  }
}
