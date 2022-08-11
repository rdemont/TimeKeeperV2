import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:timekeeperv2/business/working_slot.dart';
import 'package:timekeeperv2/utils/application.dart';
//import 'package:weekly_date_picker/weekly_date_picker.dart';
import 'package:timekeeperv2/utils/utils.dart';
import 'package:date_field/date_field.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

class WorkingAddWidget extends StatefulWidget {
  WorkingAddWidget({Key? key}) : super(key: key);

  @override
  _WorkingAddWidget createState() => _WorkingAddWidget();
}

class _WorkingAddWidget extends State<WorkingAddWidget> {
  _WorkingAddWidget() {}

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
  //PickedTime _startTime = PickedTime(h: DateTime.now().hour, m: 0);
  //PickedTime _endTime = PickedTime(h: DateTime.now().add(Duration(hours: 1)).hour, m: 0);

  PickedTime _intervalTime = PickedTime(h: 0, m: 0);

  double _workingGoal = 4.0;
  bool _isWorkingGoal = false;

  late WorkingSlot _workingSlot;

  PickedTime getPickedTime(TimeOfDay tod) {
    return PickedTime(h: tod.hour, m: tod.minute);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final WorkingSlot? args =
        ModalRoute.of(context)?.settings.arguments as WorkingSlot?;
    if (args != null) {
      _workingSlot = args;
      _isWorkingGoal = (_workingGoal >= 8.0) ? true : false;
      _intervalTime = formatIntervalTime(
          init: getPickedTime(_workingSlot.startTime),
          end: getPickedTime(_workingSlot.endTime ?? _workingSlot.startTime),
          clockTimeFormat: _clockTimeFormat);
    } else {
      Navigator.pop(context);
      print("No ARG");
      return Text(" No Arg");
      /*
      _workingSlot = Application.instance.getWorkingSlotsList().newWorkingSlot(
          Application.instance.getCurrentDate(),
          TimeOfDay.now(),
          TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 5))),
          "");
        */
    }

    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black45),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Date ',
                ),
                initialDate: _workingSlot.date,
                initialValue: _workingSlot.date,
                mode: DateTimeFieldPickerMode.date,
                autovalidateMode: AutovalidateMode.always,
                use24hFormat: true,
                validator: (e) =>
                    (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                onDateSelected: (DateTime value) {
                  _workingSlot.date = value;
                },
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Align(
                  alignment: AlignmentDirectional.center,
                  child: TimePicker(
                      initTime: getPickedTime(_workingSlot.startTime),
                      endTime: getPickedTime(
                          _workingSlot.endTime ?? _workingSlot.startTime),
                      height: 260.0,
                      width: 260.0,
                      onSelectionChange: _updateLabels,
                      onSelectionEnd: (a, b) {
                        _workingSlot.startTime =
                            new TimeOfDay(hour: a.h, minute: a.m);
                        _workingSlot.endTime =
                            new TimeOfDay(hour: b.h, minute: b.m);
                      },
                      primarySectors: _clockTimeFormat.value,
                      secondarySectors: _clockTimeFormat.value * 2,
                      decoration: TimePickerDecoration(
                        baseColor: Color(0xFF1F2633),
                        pickerBaseCirclePadding: 15.0,
                        sweepDecoration: TimePickerSweepDecoration(
                          pickerStrokeWidth: 30.0,
                          pickerColor:
                              _isWorkingGoal ? Color(0xFF3CDAF7) : Colors.black,
                          showConnector: true,
                        ),
                        initHandlerDecoration: TimePickerHandlerDecoration(
                          color: Color(0xFF141925),
                          shape: BoxShape.circle,
                          radius: 12.0,
                          icon: Icon(
                            Icons.power_settings_new_outlined,
                            size: 20.0,
                            color: Color(0xFF3CDAF7),
                          ),
                        ),
                        endHandlerDecoration: TimePickerHandlerDecoration(
                          color: Color(0xFF141925),
                          shape: BoxShape.circle,
                          radius: 12.0,
                          icon: Icon(
                            Icons.notifications_active_outlined,
                            size: 20.0,
                            color: Color(0xFF3CDAF7),
                          ),
                        ),
                        primarySectorsDecoration: TimePickerSectorDecoration(
                          color: Colors.black,
                          width: 1.0,
                          size: 4.0,
                          radiusPadding: 25.0,
                        ),
                        secondarySectorsDecoration: TimePickerSectorDecoration(
                          color: Color(0xFF3CDAF7),
                          width: 1.0,
                          size: 2.0,
                          radiusPadding: 25.0,
                        ),
                        clockNumberDecoration: TimePickerClockNumberDecoration(
                          defaultTextColor: Colors.black,
                          defaultFontSize: 12.0,
                          scaleFactor: 2.0,
                          showNumberIndicators: true,
                          clockTimeFormat: _clockTimeFormat,
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(62.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${Utils.instance.NumberFormat('0', 2, _intervalTime.h)}Hr ${Utils.instance.NumberFormat('0', 2, _intervalTime.m)}Min',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: _isWorkingGoal
                                        ? Color(0xFF3CDAF7)
                                        : Colors.yellow,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ))))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _timeWidget(
                'Start Time',
                getPickedTime(_workingSlot.startTime),
                Icon(
                  Icons.power_settings_new_outlined,
                  size: 25.0,
                  color: Color(0xFF3CDAF7),
                ),
              ),
              _timeWidget(
                'End time',
                getPickedTime(_workingSlot.endTime ?? _workingSlot.startTime),
                Icon(
                  Icons.notifications_active_outlined,
                  size: 25.0,
                  color: Color(0xFF3CDAF7),
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Description"),
                initialValue: _workingSlot.description,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  _workingSlot.description = value;
                },
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    if (_workingSlot.id == 0) {
                      Application.instance
                          .getWorkingSlotsList()
                          .add(_workingSlot);
                    }
                    //_workingSlot.valid = true;

                    _workingSlot.save();
                    //Navigator.popAndPushNamed(context, routeName)

                    Navigator.pop(context);
                    // Process data.
                  }
                },
                child: const Text('Save'),
              )),
        ]));
  }

  Widget _timeWidget(String title, PickedTime time, Icon icon) {
    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        color: Color(0xFF1F2633),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Text(
              '${Utils.instance.NumberFormat('0', 2, time.h)}:${Utils.instance.NumberFormat('0', 2, time.m)}',
              style: TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              '$title',
              style: TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            icon,
          ],
        ),
      ),
    );
  }

  void _updateLabels(PickedTime init, PickedTime end) {
    _workingSlot.startTime = TimeOfDay(hour: init.h, minute: init.m);
    _workingSlot.endTime = TimeOfDay(hour: end.h, minute: end.m);

    _intervalTime = formatIntervalTime(
        init: getPickedTime(_workingSlot.startTime),
        end: getPickedTime(_workingSlot.endTime ?? _workingSlot.startTime),
        clockTimeFormat: _clockTimeFormat);
    _isWorkingGoal = validateSleepGoal(
      inTime: init,
      outTime: end,
      sleepGoal: _workingGoal,
      clockTimeFormat: _clockTimeFormat,
    );
    setState(() {});
  }
}
