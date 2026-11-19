import 'package:flutter/material.dart';

import '../data/landmark.dart';
import '../state/app_scope.dart';
import '../widgets/app_photo.dart';
import '../widgets/page_list.dart';
import '../widgets/section_title.dart';

class ArchitectureScreen extends StatelessWidget {
  const ArchitectureScreen({super.key, required this.landmark});

  final Landmark landmark;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;
    return Scaffold(
      appBar: AppBar(title: Text(t('Архитектура', 'Сәулет', 'Architecture'))),
      body: SafeArea(
        child: PageList(
          children: [
            SectionTitle(landmark.name(state.lang)),
            InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: AppPhoto(landmark.modelPhoto, height: 350),
            ),
            Text(t(
              'Демонстрационная иллюстрация. GLB-модель будет подключена отдельно.',
              'Көрнекі сурет. GLB моделі кейін қосылады.',
              'Demo illustration. GLB model will be added separately.',
            )),
          ],
        ),
      ),
    );
  }
}
