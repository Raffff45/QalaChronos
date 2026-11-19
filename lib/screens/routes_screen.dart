import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/routes.dart';
import '../data/landmarks.dart';
import '../state/app_scope.dart';
import '../widgets/page_list.dart';

/// Исторический маршрут. Расстояние и время пока ориентировочные (из макета).
class _Walk {
  const _Walk({
    required this.names,
    required this.landmarkIds,
    required this.km,
    required this.minutes,
    required this.photo,
  });

  /// ru, kk, en
  final List<String> names;
  final List<String> landmarkIds;
  final double km;
  final int minutes;

  /// Имя файла в assets/ без расширения.
  final String photo;
}

const _walks = <_Walk>[
  _Walk(
    names: ['Исторический центр', 'Тарихи орталық', 'Historic centre'],
    landmarkIds: ['cathedral', 'theatre'],
    km: 1.8,
    minutes: 40,
    photo: 'cathedral',
  ),
  _Walk(
    names: [
      'Архитектура советской эпохи',
      'Кеңестік дәуір сәулеті',
      'Soviet-era architecture',
    ],
    landmarkIds: ['theatre'],
    km: 2.4,
    minutes: 50,
    photo: 'theatre',
  ),
];

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppScope.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('Маршруты', 'Маршруттар', 'Routes'))),
      body: SafeArea(
        child: PageList(
          children: [for (final w in _walks) _WalkCard(w)],
        ),
      ),
    );
  }
}

class _WalkCard extends StatelessWidget {
  const _WalkCard(this.walk);

  final _Walk walk;

  static const _radius = 22.0;

  static String _count(int n, int lang) {
    if (lang == 1) return '$n нысан';
    if (lang == 2) return n == 1 ? '1 landmark' : '$n landmarks';
    final m10 = n % 10;
    final m100 = n % 100;
    if (m10 == 1 && m100 != 11) return '$n объект';
    if (m10 >= 2 && m10 <= 4 && (m100 < 12 || m100 > 14)) return '$n объекта';
    return '$n объектов';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;
    final lang = state.lang;

    final km = walk.km.toStringAsFixed(1);
    final kmText = lang == 2 ? '$km km' : '${km.replaceAll('.', ',')} км';
    final minText = t('~${walk.minutes} мин', '~${walk.minutes} мин',
        '~${walk.minutes} min');

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B382F), Color(0xFF112720)],
          ),
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(color: gold.withValues(alpha: 0.35), width: 1.2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          // Экрана самого маршрута пока нет: открываем первый объект
          onTap: () => openLandmark(
            context,
            landmarks.firstWhere((l) => l.id == walk.landmarkIds.first),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(_radius)),
                child: Image.asset(
                  'assets/${walk.photo}.jpg',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            walk.names[lang],
                            style: const TextStyle(
                              color: Color(0xFFF2E3BD),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 14,
                            runSpacing: 4,
                            children: [
                              _Meta(Icons.place_outlined,
                                  _count(walk.landmarkIds.length, lang)),
                              _Meta(Icons.route_outlined, kmText),
                              _Meta(Icons.schedule, minText),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFD8BF86), Color(0xFFB8975A)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          const Icon(Icons.arrow_forward, size: 20, color: darkBg),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: gold),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
