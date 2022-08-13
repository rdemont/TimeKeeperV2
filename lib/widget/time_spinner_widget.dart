import 'package:flutter/material.dart';
import '../utils/date_extensions.dart';
import '../utils/time_of_day_extensions.dart';
import '../utils/utils.dart';

class TimeSpinnerSlot {
  TimeSpinnerSlot(TimeOfDay fromTime, TimeOfDay toTime) {
    _fromTime = fromTime;
    _toTime = toTime;
    if ((_fromTime.hour > _toTime.hour) ||
        ((_fromTime.hour == _toTime.hour) &&
            ((_fromTime.minute > _toTime.minute)))) {
      _toTime = _fromTime;
    }
  }
  late final TimeOfDay _fromTime;
  late TimeOfDay _toTime;

  TimeOfDay get fromTime {
    return _fromTime;
  }

  TimeOfDay get toTime {
    return _toTime;
  }
}

/// Create a DateTime picker widget for use in a [Dialog]
/// Can also be used outside a dialog
class TimeSpinnerWidget extends StatefulWidget {
  const TimeSpinnerWidget({
    Key? key,
    required this.maximumTime,
    required this.minimumTime,
    required this.selectedValue,
    this.minutesStep = 10,
    this.use24hFormat = true,
    this.height = 400,
    this.width = 100,
    this.visible = true,
    this.hiddenSlot = const [],
    required this.onSetTime,
  }) : super(key: key);

  /// Callback called when set time button is tapped.
  final Function(TimeOfDay) onSetTime;

  /// The maximum selectable date that the picker can settle on.
  /// Can not be null.
  final TimeOfDay maximumTime;

  /// The minimum selectable date that the picker can settle on.
  /// Can not be null.
  final TimeOfDay minimumTime;

  final TimeOfDay selectedValue;

  final double width;
  final double height;

  final bool visible;

  final List<TimeSpinnerSlot> hiddenSlot;

  /// Whether to use 24 hour format. Defaults to false.
  final bool use24hFormat;

  final int minutesStep;

  @override
  State<TimeSpinnerWidget> createState() => _TimeSpinnerWidgetState();
}

class _TimeSpinnerWidgetState extends State<TimeSpinnerWidget> {
  List<TimeOfDay> _items = [];
  //late TimeOfDay _selectedValue;
  int _selectedIndex = 0;

  CreateWidget(int index) {
    return Container(
        height: 40,
        width: widget.width,
        child: Card(
            color: _selectedIndex == index ? Colors.red : Colors.white,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 1, 16, 1),
                child: TextButton(
                  child: Text(
                      "${Utils.instance.NumberFormat("0", 2, _items[index].hour)}:${Utils.instance.NumberFormat("0", 2, _items[index].minute)}",
                      style: TextStyle(fontSize: 15)),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    //_selectedValue = _items[index];
                    widget.onSetTime(_items[index]);
                  },
                ))));
  }

  bool isHidden(TimeOfDay timeOfDay) {
    var i = 0;
    while (i < widget.hiddenSlot.length) {
      if ((widget.hiddenSlot[i].fromTime.isBefore(timeOfDay) &&
              widget.hiddenSlot[i].toTime.isAfter(timeOfDay)) ||
          (widget.hiddenSlot[i]._fromTime == timeOfDay)) {
        return true;
      }
      i++;
    }

    return false;
  }

  void createList() {
    _items.clear();

    DateTime cur = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, widget.minimumTime.hour, widget.minimumTime.minute);

    int max = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            widget.maximumTime.hour,
            widget.maximumTime.minute)
        .dateTimeItNotation;

    while (cur.dateTimeItNotation <= max) {
      if (!isHidden(cur.timeOfDay)) {
        _items.add(cur.timeOfDay);
        if ((cur.hour <= widget.selectedValue.hour) &&
            (cur.minute <= widget.selectedValue.minute)) {
          _selectedIndex = _items.length - 1;
        }
      }
      cur = cur.add(Duration(minutes: widget.minutesStep));
    }
  }

  @override
  void initState() {
    super.initState();
    createList();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController listScrollController = ScrollController(
        initialScrollOffset: (_selectedIndex * 40) - (widget.height / 2));
    return Visibility(
        visible: widget.visible,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Container(
            height: widget.height,
            width: widget.width,
            child: ListView.builder(
              controller: listScrollController,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return CreateWidget(index);
              },
            )));
  }
}
