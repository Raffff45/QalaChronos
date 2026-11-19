import 'package:flutter/material.dart';

/// Картинка из assets/ со скруглёнными углами. [name] — без расширения.
class AppPhoto extends StatelessWidget {
  const AppPhoto(this.name, {super.key, this.height = 220});

  final String name;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/$name.jpg',
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
