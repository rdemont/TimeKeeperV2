import 'package:flutter/material.dart';
import 'package:timekeeperv2/business/working_slot.dart';
import 'package:timekeeperv2/utils/application.dart';
import 'package:timekeeperv2/utils/date_extensions.dart';

class DropDownWidget extends StatefulWidget {
  DropDownWidget({
    Key? key,
    required this.items,
    this.defaultIndex,
    this.onChange,
  }) : super(key: key);

  List<DropdownMenuItem<String>> items;
  int? defaultIndex;
  final Function(int index)? onChange;

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  //List<DropdownMenuItem<String>> _ddMonth = [];

  String defaultValue = "";
  @override
  void initState() {
    super.initState();
    defaultValue = widget.items[widget.defaultIndex ?? 0].value ?? "";
  }

  //Your build method
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Which month you want to export :  '),
        DropdownButton<String>(
          value: defaultValue,
          items: widget.items,
          onChanged: (newValue) {
            setState(() {
              defaultValue = newValue ?? "";
              int i = 0;
              while ((newValue != widget.items[i].value) &&
                  (i < widget.items.length)) {
                i++;
              }
              widget.onChange!(i);
            });
          },
        ),
      ],
    );
  }
}
