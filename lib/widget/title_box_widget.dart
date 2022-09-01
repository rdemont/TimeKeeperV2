import 'package:flutter/material.dart';

class TitleBox extends StatefulWidget {
  const TitleBox({
    Key? key,
    required this.title,
    required this.child,
    this.onClickHelp,
    this.showHelp = true,
    this.titleFontSize = 15,
    this.titleLeft = 30,
    this.titleTop = 5,
    this.margin = const EdgeInsets.fromLTRB(10, 20, 10, 0),
    this.padding = const EdgeInsets.all(10.0),
  }) : super(key: key);

  final String title;
  final Widget child;
  final Function(TimeOfDay)? onClickHelp;
  final bool showHelp;
  final double titleFontSize;
  final double titleLeft;
  final double titleTop;
  final EdgeInsets margin;
  final EdgeInsets padding;

  @override
  State<TitleBox> createState() => _TitleBoxState();
}

class _TitleBoxState extends State<TitleBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: widget.margin,
          padding: widget.padding,
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
                        fontSize: widget.titleFontSize,
                        color: Colors.black))),
            left: widget.titleLeft,
            top: widget.titleTop),
        Visibility(
            visible: widget.showHelp,
            child: Positioned(
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
                        if (widget.onClickHelp != null) {
                          widget.onClickHelp;
                        }
                      },
                    )),
                right: 30,
                top: 5)),
      ],
    );
  }
}
