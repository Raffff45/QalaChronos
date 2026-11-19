import 'package:flutter/material.dart';

import '../data/landmark.dart';
import '../screens/architecture_screen.dart';
import '../screens/landmark_screen.dart';
import '../screens/time_machine_screen.dart';

void openLandmark(BuildContext context, Landmark landmark) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => LandmarkScreen(landmark: landmark)),
  );
}

void openArchitecture(BuildContext context, Landmark landmark) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ArchitectureScreen(landmark: landmark)),
  );
}

void openTimeMachine(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const TimeMachineScreen()),
  );
}
