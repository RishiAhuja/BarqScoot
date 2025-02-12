import 'package:flutter/material.dart';

class ScanOverlay extends StatelessWidget {
  const ScanOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScanOverlayPainter(),
      child: Container(),
    );
  }
}

class ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final scanAreaSize = size.width * 0.7;
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2;
    final right = left + scanAreaSize;
    final bottom = top + scanAreaSize;

    // Draw semi-transparent overlay
    Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTRB(left, top, right, bottom));

    canvas.drawPath(path, paint);

    // Draw scan area border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(
      Rect.fromLTRB(left, top, right, bottom),
      borderPaint,
    );

    // Draw corner markers
    final markerLength = scanAreaSize * 0.1;
    final cornerPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Top left corner
    canvas.drawLine(
        Offset(left, top + markerLength), Offset(left, top), cornerPaint);
    canvas.drawLine(
        Offset(left, top), Offset(left + markerLength, top), cornerPaint);

    // Top right corner
    canvas.drawLine(
        Offset(right - markerLength, top), Offset(right, top), cornerPaint);
    canvas.drawLine(
        Offset(right, top), Offset(right, top + markerLength), cornerPaint);

    // Bottom left corner
    canvas.drawLine(
        Offset(left, bottom - markerLength), Offset(left, bottom), cornerPaint);
    canvas.drawLine(
        Offset(left, bottom), Offset(left + markerLength, bottom), cornerPaint);

    // Bottom right corner
    canvas.drawLine(Offset(right - markerLength, bottom), Offset(right, bottom),
        cornerPaint);
    canvas.drawLine(Offset(right, bottom), Offset(right, bottom - markerLength),
        cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
