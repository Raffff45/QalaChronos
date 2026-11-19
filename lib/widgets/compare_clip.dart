import 'package:flutter/material.dart';

/// Обрезает картинку по вертикальной линии (для слайдера «раньше / сейчас»).
class CompareClipper extends CustomClipper<Rect> {
  CompareClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(CompareClipper oldClipper) => oldClipper.fraction != fraction;
}
