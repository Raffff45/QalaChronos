import 'package:flutter/material.dart';

import '../data/landmark.dart';
import '../screens/architecture_screen.dart';
import '../screens/landmark_screen.dart';
import '../screens/tabs/map_tab.dart';
import '../screens/time_machine_screen.dart';
import '../state/app_scope.dart';

// Открытие архитектурного объекта
void openLandmark(BuildContext context, Landmark landmark) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => LandmarkScreen(landmark: landmark),
    ),
  );
}

// Открытие 3D-модели
void openArchitecture(BuildContext context, Landmark landmark) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ArchitectureScreen(landmark: landmark),
    ),
  );
}

// Открытие машины времени
void openTimeMachine(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const TimeMachineScreen(),
    ),
  );
}

// Открытие карты объектов
void openMap(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (ctx) {
        final t = AppScope.of(ctx).t;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              t(
                'Карта объектов',
                'Нысандар картасы',
                'Landmark map',
              ),
            ),
          ),
          body: const SafeArea(
            child: MapTab(showTitle: false),
          ),
        );
      },
    ),
  );
}

// Открытие маршрутов
void openRoutes(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const RoutesScreen(),
    ),
  );
}

// Экран маршрутов
class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppScope.of(context).t;

    return Scaffold(
      backgroundColor: const Color(0xFF101C19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101C19),
        foregroundColor: const Color(0xFFC6AD7C),
        title: Text(
          t('Маршруты', 'Маршруттар', 'Routes'),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.route_rounded,
              size: 80,
              color: Color(0xFFC6AD7C),
            ),
            const SizedBox(height: 24),
            Text(
              t(
                'Исторические маршруты',
                'Тарихи маршруттар',
                'Historical routes',
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC6AD7C),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              t(
                'Скоро здесь появятся маршруты',
                'Жақында маршруттар қосылады',
                'Routes coming soon',
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}