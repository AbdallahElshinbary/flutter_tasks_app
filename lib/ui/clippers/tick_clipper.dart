import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  double fraction;
  Color color;

  MyPainter(this.fraction, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double m = (size.height / 2) + (size.height / 4);
    double firstFraction, secondFraction;

    if (fraction < 0.5) {
      firstFraction = fraction / 0.5;
      secondFraction = 0.0;
    } else {
      firstFraction = 1.0;
      secondFraction = (fraction - 0.5) / 0.5;
    }

    Paint line = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    canvas.drawLine(
      Offset(0.0, size.height / 2),
      Offset(size.width / 3 * firstFraction, (size.height / 2) + ((size.height / 4) * firstFraction)),
      line,
    );
    if (fraction >= 0.5) {
      canvas.drawLine(
        Offset(size.width / 3, m),
        Offset((size.width - size.width / 3) * secondFraction + (size.width / 3), m - (m * secondFraction)),
        line,
      );
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
