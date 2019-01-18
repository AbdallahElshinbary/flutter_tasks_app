import 'dart:ui';
import 'package:flutter/material.dart';
import '../clippers/tick_clipper.dart';

class Tick extends StatefulWidget {
  @override
  _TickState createState() => _TickState();
}

class _TickState extends State<Tick> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  double fraction = 0.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller))
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: 300,
            height: 200,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.grey.shade100.withOpacity(0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  child: CustomPaint(
                    painter: MyPainter(fraction, Colors.blueGrey[700]),
                  ),
                  padding: EdgeInsets.all(10.0),
                ),
                Text(
                  "Added Successfully",
                  style: TextStyle(
                    color: Colors.blueGrey[600],
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
