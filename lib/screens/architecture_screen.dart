import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../core/app_theme.dart';
import '../data/landmark.dart';
import '../state/app_scope.dart';
import '../widgets/landmark_avatar.dart';

/// Экран с интерактивной 3D-моделью объекта (GLB): вращение и масштаб пальцами.
class ArchitectureScreen extends StatelessWidget {
  const ArchitectureScreen({super.key, required this.landmark});

  final Landmark landmark;

  /// model_viewer_plus работает на Android, iOS и в вебе (на Windows/Linux/macOS нет).
  static bool get _supports3d =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;
    final name = landmark.name(state.lang);

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _supports3d
                  ? ModelViewer(
                      // Ключ по объекту: при смене модели вьюер пересоздаётся
                      key: ValueKey(landmark.id),
                      src: landmark.model,
                      alt: name,
                      ar: false,
                      autoRotate: true,
                      cameraControls: true,
                      backgroundColor: darkBg,
                    )
                  : _NoViewer(landmark: landmark),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  const Icon(Icons.threed_rotation, color: gold, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t(
                        'Проведите пальцем, чтобы вращать. Двумя пальцами: масштаб.',
                        'Айналдыру үшін саусақпен жылжытыңыз. Екі саусақ: масштаб.',
                        'Drag to rotate. Pinch to zoom.',
                      ),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Запасной вариант для платформ, где 3D-вьюера нет (например, Windows).
class _NoViewer extends StatelessWidget {
  const _NoViewer({required this.landmark});

  final Landmark landmark;

  @override
  Widget build(BuildContext context) {
    final t = AppScope.of(context).t;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LandmarkAvatar(landmark, size: 200, borderWidth: 3),
            const SizedBox(height: 20),
            Text(
              t(
                '3D-модель доступна на Android и iOS.',
                '3D-модель Android және iOS құрылғыларында қолжетімді.',
                '3D model is available on Android and iOS.',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}