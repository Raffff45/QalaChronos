import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/routes.dart';
import '../../data/landmarks.dart';
import '../../state/app_scope.dart';
import '../../widgets/landmark_card.dart';
import '../../widgets/map_sketch.dart';
import '../../widgets/page_list.dart';
import '../../widgets/section_title.dart';

class MapTab extends StatelessWidget {
  const MapTab({super.key});

  static const _mapHeight = 390.0;

  @override
  Widget build(BuildContext context) {
    final t = AppScope.of(context).t;
    return PageList(
      children: [
        SectionTitle(t('Карта Алматы', 'Алматы картасы', 'Almaty map')),
        SizedBox(
          height: _mapHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: InteractiveViewer(
              maxScale: 4,
              child: LayoutBuilder(
                builder: (context, box) => Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: MapSketchPainter()),
                    ),
                    for (final l in landmarks)
                      Positioned(
                        left: box.maxWidth * l.mapX,
                        top: _mapHeight * l.mapY,
                        child: IconButton(
                          onPressed: () => openLandmark(context, l),
                          icon: const Icon(Icons.location_on, size: 40, color: darkBg),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Text(t(
          'Схематичная карта · не для навигации',
          'Сызбалық карта',
          'Illustrative map · not for navigation',
        )),
        for (final l in landmarks) LandmarkCard(l),
      ],
    );
  }
}
