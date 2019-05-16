library dashed_container;

import 'dart:ui';

import 'package:flutter/material.dart';

part 'dash_path_painter.dart';

part 'dash_offset.dart';

class DashedContainer extends StatelessWidget {
  final Color dashColor;

  /// Width of the stroke, default is 1.0
  final double strokeWidth;

  /// Length of blank space, default 5.0
  final double blankLength;

  /// Length of dashed line, default 5.0
  final double dashedLength;
  final Widget child;
  final double borderRadius;
  final BoxShape boxShape;

  DashedContainer({
    @required this.child,
    this.dashColor = Colors.black,
    this.strokeWidth = 1.0,
    this.blankLength = 5.0,
    this.dashedLength = 5.0,
    this.borderRadius = 0.0,
    this.boxShape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final Paint mPaint = Paint()
      ..color = dashColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    return CustomPaint(
      painter: DashPathPainter(
        mPaint: mPaint,
        blankWidth: blankLength,
        dashedWidth: dashedLength,
        borderRadius: borderRadius,
        boxShape: boxShape,
      ),
      child: child,
    );
  }
}
