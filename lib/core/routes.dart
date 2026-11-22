import 'package:flutter/material.dart';

import '../data/landmark.dart';
import '../screens/architecture_screen.dart';
import '../screens/landmark_screen.dart';
import '../screens/models_screen.dart';
import '../screens/routes_screen.dart';
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

// Галерея 3D-моделей
void openModels(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ModelsScreen(),
    ),
  );
}