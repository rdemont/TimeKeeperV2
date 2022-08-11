import 'package:flutter/material.dart';
import 'package:timekeeperv2/business/working_slot.dart';
import 'package:timekeeperv2/main.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      required this.workingSlotsList})
      : super(key: key);

  final double height;
  final double width;
  DateTime currentDate;
  WorkingSlotsList workingSlotsList;
  int viewType;
  final Function(WorkingSlot ws) onAdd;

  @override
  _ContextFooterWidget createState() => _ContextFooterWidget();
}

class _ContextFooterWidget extends State<ContextFooterWidget> {
  _ContextFooterWidget();

  @override
  Widget build(BuildContext context) {
    int minutes = widget.workingSlotsList.sumMinutes();
    bool isWorking = Application.instance.isWorking();
    String buttonIsWorkingTxt =
        Application.instance.isWorking() ? 'Is Working' : 'Start working';
    return Row(children: [
      Container(
        width: (widget.width / 3) - 40,
        padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
        child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text("HMin:" +
                Utils.instance.humainReadableMinutesPerHour(minutes) +
                "\nHDec:" +
                Utils.instance.humainReadableDecimalPerHour(minutes))),
      ),
      Container(
          width: (widget.width / 3) + 40,
          child: Align(
              alignment: AlignmentDirectional.center,
              child: SizedBox(
                  height: widget.height - 10,
                  width: (widget.width / 3) + 40 - 6,
                  child: TextButton(
                      style: ElevatedButton.styleFrom(
                          primary:
                              isWorking ? Colors.red : Colors.blue.shade900,
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      onPressed: () {
                        if (Application.instance.isWorking()) {
                          WorkingSlot? ws = Application.instance.endWorking();
                          if (ws != null) {
                            Application.instance.getWorkingSlotsList().add(ws);
                            ws.save();
                          }
                        } else {
                          Application.instance.startWorking();
                        }
                        setState(() {
                          buttonIsWorkingTxt = Application.instance.isWorking()
                              ? 'Is Working'
                              : 'Start working';
                          isWorking = Application.instance.isWorking();
                        });
                      },
                      child: Text(buttonIsWorkingTxt,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white)))))),
      Container(
          width: widget.width / 3,
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
                      widget.onAdd(WorkingSlot.create(
                          widget.currentDate,
                          TimeOfDay(
                              hour: DateTime.now().hour,
                              minute: DateTime.now().hour),
                          TimeOfDay(
                              hour: DateTime.now().add(Duration(hours: 1)).hour,
                              minute: DateTime.now().minute),
                          ""));
                    },
                    child: Text("add time",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white))),
              )))
    ]);
  }
}
