import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/landmark.dart';

/// Круглая аватарка объекта в золотой рамке.
/// У исходных PNG есть своя синяя кайма: небольшое увеличение скрывает её,
/// чтобы не получалось двух колец.
class LandmarkAvatar extends StatelessWidget {
  const LandmarkAvatar(
    this.landmark, {
    super.key,
    this.size = 64,
    this.borderWidth = 2,
  });

  final Landmark landmark;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final px = (size * MediaQuery.devicePixelRatioOf(context)).round();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: darkBg,
        border: Border.all(color: gold, width: borderWidth),
      ),
      child: ClipOval(
        child: Transform.scale(
          scale: 1.12,
          child: Image.asset(
            landmark.avatar,
            fit: BoxFit.cover,
            cacheWidth: px,
            filterQuality: FilterQuality.medium,
          ),
        ),
      ),
    );
  }
}

/// Крупная «обложка» объекта для верха экрана: аватарка по центру на тёмном градиенте.
class LandmarkHero extends StatelessWidget {
  const LandmarkHero(this.landmark, {super.key, this.height = 260});

  final Landmark landmark;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold.withValues(alpha: 0.35), width: 1.2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B382F), Color(0xFF112720)],
        ),
      ),
      child: Center(
        child: LandmarkAvatar(landmark, size: height - 48, borderWidth: 3),
      ),
    );
  }
}