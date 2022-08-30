import 'package:flutter/material.dart';

class TitleBox extends StatefulWidget {
  const TitleBox({
    Key? key,
    required this.title,
    required this.child,
    required this.onClickHelp,
  }) : super(key: key);

  final String title;
  final Widget child;
  final Function(TimeOfDay) onClickHelp;

  @override
  State<TitleBox> createState() => _TitleBoxState();
}

class _TitleBoxState extends State<TitleBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blueAccent, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: widget.child,
        ),
        Positioned(
            child: Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blueAccent, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Text(widget.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black))),
            left: 30,
            top: 5),
        Positioned(
            child: Container(
                height: 35,
                width: 35,
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blueAccent, width: 3),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10.0))),
                child: IconButton(
                  iconSize: 25,
                  padding: const EdgeInsets.all(0.0),
                  alignment: AlignmentDirectional.center,
                  icon: Icon(Icons.help, color: Colors.blue, size: 25),
                  onPressed: () {
                    widget.onClickHelp;
                  },
                )),
            right: 30,
            top: 5),
      ],
    );
  }
}
