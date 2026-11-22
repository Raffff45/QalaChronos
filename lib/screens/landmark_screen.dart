import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_theme.dart';
import '../core/routes.dart';
import '../data/landmark.dart';
import '../state/app_scope.dart';
import '../widgets/landmark_avatar.dart';
import '../widgets/page_list.dart';
import '../widgets/section_title.dart';
import '../widgets/wide_button.dart';

class LandmarkScreen extends StatelessWidget {
  const LandmarkScreen({super.key, required this.landmark});

  final Landmark landmark;

  static const _panoramaUrl = 'https://yandex.kz/maps/ru/162/almaty/panorama/';

  Future<void> _openPanorama() {
    return launchUrl(
      Uri.parse(_panoramaUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;
    final isFav = state.isFav(landmark.id);

    return Scaffold(
      appBar: AppBar(title: Text(landmark.name(state.lang))),
      body: SafeArea(
        child: PageList(
          children: [
            LandmarkHero(landmark),
            SectionTitle(landmark.name(state.lang)),
            Text(
              landmark.year,
              style: const TextStyle(color: gold, fontSize: 20),
            ),
            Text(landmark.description(state.lang)),
            WideButton(
              t('Смотреть 3D-модель', '3D-модельді көру', 'View 3D model'),
              () => openArchitecture(context, landmark),
            ),
            if (landmark.hasThenNow)
              WideButton(
                t('Раньше и сейчас', 'Бұрын және қазір', 'Then and now'),
                () => openTimeMachine(context),
              ),
            WideButton(
              t('Панорамы Алматы', 'Алматы панорамалары', 'Almaty panoramas'),
              _openPanorama,
            ),
            WideButton(
              isFav
                  ? t('Убрать из избранного', 'Таңдаулыдан жою', 'Remove favorite')
                  : t('В избранное', 'Таңдаулыға', 'Favorite'),
              () => state.toggleFav(landmark.id),
            ),
            WideButton(
              t('Отметить изученным', 'Зерттелді', 'Mark explored'),
              () {
                state.markSeen(landmark.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}