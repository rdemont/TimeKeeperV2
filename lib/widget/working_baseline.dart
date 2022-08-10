import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timekeeperv2/business/working_slot.dart';
import 'package:timekeeperv2/utils/application.dart';
import 'package:timekeeperv2/utils/utils.dart';
import 'package:week_of_year/week_of_year.dart';
import "package:weekly_date_picker/datetime_apis.dart";

class WorkingBaseline extends StatefulWidget {
  WorkingBaseline({Key? key, this.minutes = 0, this.onPop}) : super(key: key);

  /// The current selected day
  final int minutes;
  final onPop;

  @override
  _WorkingBaselineState createState() => _WorkingBaselineState();
}

class _WorkingBaselineState extends State<WorkingBaseline> {
  //late int _minutes = 0;
  bool isWorking = Application.instance.isWorking();

  String buttonIsWorkingTxt =
      Application.instance.isWorking() ? 'Is Working' : 'Start working';

  @override
  void initState() {
    super.initState();
    //_minutes = widget.minutes;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //color: Colors.yellow,
        height: 60,
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                color: Colors.lightBlue,
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Divider(
                        height: 2,
                        thickness: 2,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    Row(children: [
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width - 20) / 3) - 40,
                        child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text("HMin:" +
                                Utils.instance.humainReadableMinutesPerHour(
                                    widget.minutes) +
                                "\nHDec:" +
                                Utils.instance.humainReadableDecimalPerHour(
                                    widget.minutes))),
                      ),
                      Container(
                          width:
                              ((MediaQuery.of(context).size.width - 20) / 3) +
                                  40,
                          child: Align(
                              alignment: AlignmentDirectional.center,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: isWorking
                                          ? Colors.red
                                          : Colors.blue.shade900,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 5),
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    if (Application.instance.isWorking()) {
                                      WorkingSlot? ws =
                                          Application.instance.endWorking();
                                      if (ws != null) {
                                        Application.instance
                                            .getWorkingSlotsList()
                                            .add(ws);
                                        ws.save();
                                      }
                                    } else {
                                      Application.instance.startWorking();
                                    }
                                    setState(() {
                                      buttonIsWorkingTxt =
                                          Application.instance.isWorking()
                                              ? 'Is Working'
                                              : 'Start working';
                                      isWorking =
                                          Application.instance.isWorking();
                                    });
                                  },
                                  child: Text(buttonIsWorkingTxt)))),
                      Container(
                          width: (MediaQuery.of(context).size.width - 20) / 3,
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue.shade900,
                                  shape: const BeveledRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                onPressed: () {
                                  WorkingSlot ws = WorkingSlot(
                                      0,
                                      Application.instance.getCurrentDate(),
                                      TimeOfDay.now(),
                                      TimeOfDay.fromDateTime(DateTime.now()
                                          .add(Duration(hours: 1))),
                                      "");

                                  Navigator.pushNamed(context, '/add',
                                          arguments: ws)
                                      .then(widget.onPop);
                                },
                                child: Text("add time",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white))),
                          ))
                    ])
                  ],
                ))));
  }
/*
 FutureOr onPop(Object? value) {
    setDate(Application.instance.getCurrentDate());
  }
*/
}
