import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/routes.dart';
import '../data/landmarks.dart';
import '../state/app_scope.dart';
import '../widgets/landmark_avatar.dart';

/// Галерея всех 3D-моделей: нажатие открывает модель объекта.
class ModelsScreen extends StatelessWidget {
  const ModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;

    return Scaffold(
      appBar: AppBar(title: Text(t('3D-модели', '3D-модельдер', '3D models'))),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemCount: landmarks.length,
              itemBuilder: (context, i) {
                final l = landmarks[i];
                return Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1B382F), Color(0xFF112720)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: gold.withValues(alpha: 0.35), width: 1.2),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => openArchitecture(context, l),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, box) => Center(
                                  child: LandmarkAvatar(
                                    l,
                                    size: box.biggest.shortestSide.clamp(60.0, 140.0).toDouble(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l.name(state.lang),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFF2E3BD),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.view_in_ar_outlined, size: 14, color: gold),
                                const SizedBox(width: 4),
                                Text(
                                  l.year,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}