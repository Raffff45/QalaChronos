import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../data/landmark.dart';
import '../state/app_scope.dart';
import 'landmark_avatar.dart';

class LandmarkCard extends StatelessWidget {
  const LandmarkCard(this.landmark, {super.key});

  final Landmark landmark;

  @override
  Widget build(BuildContext context) {
    final lang = AppScope.of(context).lang;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: LandmarkAvatar(landmark, size: 56),
        title: Text(landmark.name(lang)),
        subtitle: Text(landmark.year),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => openLandmark(context, landmark),
      ),
    );
  }
}