part of dashed_container;

class DashPathPainter extends CustomPainter {
  final Paint mPaint;
  final double? blankWidth;
  final double? dashedWidth;
  final double? borderRadius;
  final BoxShape? boxShape;

  DashPathPainter({
    required this.mPaint,
    this.blankWidth,
    this.dashedWidth,
    this.borderRadius,
    this.boxShape,
  });

  @override
  bool shouldRepaint(DashPathPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Path p;
    double? bRadius = borderRadius;

    if (boxShape == BoxShape.rectangle) {
      if (bRadius == 0)
        p = Path()..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
      else {
        Radius radius = Radius.circular(bRadius!);
        p = Path()
          ..addRRect(
            RRect.fromRectAndCorners(
              Rect.fromLTWH(0.0, 0.0, size.width, size.height),
              bottomLeft: radius,
              bottomRight: radius,
              topLeft: radius,
              topRight: radius,
            ),
          );
      }
    } else {
      bRadius = size.width / 2;
      Radius radius = Radius.circular(bRadius);
      p = Path()
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(0.0, 0.0, size.width, size.height),
            bottomLeft: radius,
            bottomRight: radius,
            topLeft: radius,
            topRight: radius,
          ),
        );
    }
    canvas.drawPath(
      dashPath(
        p,
        dashArray: CircularIntervalList<double?>(
          <double?>[
            dashedWidth,
            blankWidth,
          ],
        ),
      ),
      mPaint,
    );
  }
}

/// Creates a new path that is drawn from the segments of `source`.
///
/// Dash intervals are controled by the `dashArray` - see [CircularIntervalList]
/// for examples.
///
/// `dashOffset` specifies an initial starting point for the dashing.
///
/// Passing in a null `source` will result in a null result.  Passing a `source`
/// that is an empty path will return an empty path.
Path dashPath(
  Path source, {
  required CircularIntervalList<double?> dashArray,
  DashOffset? dashOffset,
}) {
  assert(dashArray != null);

  dashOffset = dashOffset ?? const DashOffset.absolute(0.0);
  // TODO: Is there some way to determine how much of a path would be visible today?

  final Path dest = Path();
  for (final PathMetric metric in source.computeMetrics()) {
    double distance = dashOffset._calculate(metric.length);
    bool draw = true;
    while (distance < metric.length) {
      final double len = dashArray.next!;
      if (draw) {
        dest.addPath(metric.extractPath(distance, distance + len), Offset.zero);
      }
      distance += len;
      draw = !draw;
    }
  }

  return dest;
}
