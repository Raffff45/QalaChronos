import 'package:flutter/material.dart';

/// Схематичная карта (заглушка, пока нет настоящей).
class MapSketchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xffd9cdb1));

    final road = Paint()
      ..color = const Color(0xfffaf1db)
      ..strokeWidth = 9;
    for (int i = -4; i < 14; i++) {
      canvas.drawLine(
        Offset(i * 55.0, 0),
        Offset(i * 55.0 + 120, size.height),
        road,
      );
      canvas.drawLine(
        Offset(0, i * 49.0),
        Offset(size.width, i * 49.0 - 65),
        road,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .50, 54, 90, 85),
        const Radius.circular(12),
      ),
      Paint()..color = const Color(0xff99ad78),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
