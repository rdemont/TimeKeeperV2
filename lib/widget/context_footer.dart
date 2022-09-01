import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:timekeeperv2/main.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timekeeperv2/widget/title_box_widget.dart';

import '../business/time_slot.dart';
import '../utils/application.dart';
import '../utils/utils.dart';
import 'daily_picker.dart';

class ContextFooterWidget extends StatefulWidget {
  ContextFooterWidget(
      {Key? key,
      required this.height,
      required this.width,
      required this.currentDate,
      required this.viewType,
      required this.onAdd,
      required this.timeSlotList})
      : super(key: key);

  final double height;
  final double width;
  DateTime currentDate;
  TimeSlotList timeSlotList;
  int viewType;
  final Function(TimeSlot timeSlot) onAdd;

  @override
  _ContextFooterWidget createState() => _ContextFooterWidget();
}

class _ContextFooterWidget extends State<ContextFooterWidget> {
  _ContextFooterWidget();

  int minutesOverLap = 0;
  bool _isWorking = false;
  @override
  Widget build(BuildContext context) {
    int minutes = widget.timeSlotList.minutes;

    widget.timeSlotList.minutesOverLap.then((value) {
      if (minutesOverLap != value) {
        setState(() {
          minutesOverLap = value;
        });
      }
    });
    Application.instance.isWorking().then((value) {
      if (_isWorking != value) {
        setState(() {
          _isWorking = value;
        });
      }
    });

    double _infoBox = 80;

    return Row(children: [
      Container(
        width: _infoBox,
        child: TitleBox(
            title: AppLocalizations.of(context)!.working_time,
            showHelp: false,
            titleFontSize: 10,
            titleLeft: 5,
            titleTop: 0,
            margin: const EdgeInsets.fromLTRB(2, 15, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: SizedBox(
                width: _infoBox,
                height: 40,
                child: Column(
                  children: [
                    Text(Utils.instance.humainReadableMinutesPerHour(minutes),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black)),
                    Text(Utils.instance.humainReadableDecimalPerHour(minutes),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black))
                  ],
                ))),
      ),
      Container(
        width: _infoBox,
        child: TitleBox(
            title: AppLocalizations.of(context)!.extra_time,
            showHelp: false,
            titleFontSize: 10,
            titleLeft: 5,
            titleTop: 0,
            margin: const EdgeInsets.fromLTRB(2, 15, 2, 0),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: SizedBox(
                width: _infoBox,
                height: 40,
                child: Column(
                  children: [
                    Text(
                        Utils.instance
                            .humainReadableMinutesPerHour(minutesOverLap),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black)),
                    Text(
                        Utils.instance
                            .humainReadableDecimalPerHour(minutesOverLap),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black))
                  ],
                ))),
      ),
      Container(
          width: (widget.width - _infoBox - _infoBox),
          child: Align(
              alignment: AlignmentDirectional.center,
              child: SizedBox(
                  height: widget.height - 10,
                  width: (widget.width / 3) + 40 - 6,
                  child: TextButton(
                      style: ElevatedButton.styleFrom(
                          primary:
                              _isWorking ? Colors.red : Colors.blue.shade900,
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      onPressed: () {
                        Application.instance.endWorking().then((value) {
                          if (value != null) {
                            widget.onAdd(value);
                          } else {
                            Application.instance.startWorking();
                          }
                          setState(() {
                            _isWorking = !_isWorking;
                          });
                        });
                      },
                      child: Text(
                          _isWorking
                              ? AppLocalizations.of(context)!.stop_working
                              : AppLocalizations.of(context)!.start_working,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white)))))),
    ]);
  }
}



/*
Container(
          width: ((widget.width - 60 - 60) / 2) - 20,
          child: Align(
              alignment: AlignmentDirectional.center,
              child: SizedBox(
                height: 50,
                width: (widget.width / 3) - 20,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    onPressed: () {
                      widget.onAdd(TimeSlot.create(
                          widget.currentDate,
                          TimeOfDay(
                              hour: DateTime.now().hour,
                              minute: DateTime.now().hour),
                          TimeOfDay(
                              hour: DateTime.now().add(Duration(hours: 1)).hour,
                              minute: DateTime.now().minute),
                          ""));
                    },
                    child: Text(AppLocalizations.of(context)!.add_time,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white))),
              )))
              */