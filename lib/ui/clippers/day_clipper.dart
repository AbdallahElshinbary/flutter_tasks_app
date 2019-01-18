import 'package:flutter/material.dart';

class DayClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = new Path();
    path.lineTo(0, size.height - (size.height / 4));

    final end1 = Offset(size.width, 100);
    final control1 = Offset(size.width / 4, size.height * 1.2);

    path.quadraticBezierTo(control1.dx, control1.dy, end1.dx, end1.dy);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
