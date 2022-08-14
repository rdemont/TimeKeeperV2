import 'package:flutter/material.dart';
import 'package:timekeeperv2/business/working_slot.dart';
import 'package:timekeeperv2/utils/application.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:share_plus/share_plus.dart';

class DropDownWidget extends StatefulWidget {
  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  List<DropdownMenuItem<String>> _ddMonth = [];

  initDropDownList() {
    _ddMonth.clear();
    DateTime dt = DateTime.now().firstDayOfTheMonth;
    for (int i = 0; i < 13; i++) {
      _ddMonth.add(DropdownMenuItem(
        value: dt.formated("yyyyMM"),
        child: Text(dt.formated("MMMM yyyy")),
      ));
      dt = dt.add(Duration(days: -1)).firstDayOfTheMonth;
    }
    //_ddMonthValue = _ddMonth[1].value ?? "";
  }

  @override
  void initState() {
    super.initState();
    DateTime dt = DateTime.now()
        .firstDayOfTheMonth
        .add(Duration(days: -1))
        .firstDayOfTheMonth;
    _ddMonthValue = dt.formated("yyyyMM");
    changeDate(dt);
  }

  late WorkingSlotsList _wsl;
  void changeDate(DateTime dt) {
    _wsl = Application.instance
        .getWorkingSlotsList()
        .perYearMonth(dt.year, dt.month);
  }

  String _ddMonthValue = "";

  void _onShare(BuildContext context, String text, String subject) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;

    if (text.length == 0) {
      text = subject;
    }

    await Share.share(text,
        subject: subject,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  //Your build method
  @override
  Widget build(BuildContext context) {
    initDropDownList();

    return Column(
      children: <Widget>[
        Text('Which month you want to export :  '),
        DropdownButton<String>(
          value: _ddMonthValue,
          items: _ddMonth,
          onChanged: (newValue) {
            setState(() {
              _ddMonthValue = newValue ?? _ddMonth[2].value ?? "";
              DateTime dt = DateTime(int.parse(_ddMonthValue.substring(0, 4)),
                  int.parse(_ddMonthValue.substring(4, 6)), 1);
              changeDate(dt);
              print(_ddMonthValue);
            });
          },
        ),
        TextButton(
            onPressed: () {
              _onShare(context, _wsl.csv(), "Test CSV");
              print("Export");
            },
            child: Text("Export"))
      ],
    );
  }
}
