import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/landmark.dart';
import '../data/landmarks.dart';
import '../state/app_scope.dart';
import '../widgets/landmark_avatar.dart';
import '../widgets/landmark_card.dart';
import '../widgets/page_list.dart';
import '../widgets/section_title.dart';

/// Исторический маршрут.
/// Длина и время ориентировочные: считаются по прямым между объектами
/// с запасом на изгибы улиц (пешком ~4,5 км/ч).
class _Walk {
  const _Walk({
    required this.names,
    required this.landmarkIds,
    required this.km,
    required this.minutes,
  });

  /// ru, kk, en
  final List<String> names;
  final List<String> landmarkIds;
  final double km;
  final int minutes;

  List<Landmark> get stops => [
        for (final id in landmarkIds) landmarks.firstWhere((l) => l.id == id),
      ];
}

const _walks = <_Walk>[
  _Walk(
    names: ['Исторический центр', 'Тарихи орталық', 'Historic centre'],
    landmarkIds: ['cathedral', 'theatre'],
    km: 1.7,
    minutes: 25,
  ),
  _Walk(
    names: [
      'Архитектура советской эпохи',
      'Кеңестік дәуір сәулеті',
      'Soviet-era architecture',
    ],
    landmarkIds: [
      'hotel_kazakhstan',
      'republic_palace',
      'schoolchildren_palace',
      'central_museum',
    ],
    km: 1.9,
    minutes: 25,
  ),
  _Walk(
    names: [
      'Театры и цирк на проспекте Абая',
      'Абай даңғылындағы театрлар мен цирк',
      'Theatres and circus on Abay Avenue',
    ],
    landmarkIds: ['auezov_theatre', 'circus', 'theatre'],
    km: 3.6,
    minutes: 50,
  ),
];

String _countText(int n, int lang) {
  if (lang == 1) return '$n нысан';
  if (lang == 2) return n == 1 ? '1 landmark' : '$n landmarks';
  final m10 = n % 10;
  final m100 = n % 100;
  if (m10 == 1 && m100 != 11) return '$n объект';
  if (m10 >= 2 && m10 <= 4 && (m100 < 12 || m100 > 14)) return '$n объекта';
  return '$n объектов';
}

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

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final lang = state.lang;

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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => _WalkScreen(walk)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AvatarStrip(walk.stops),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 12, 14),
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
                          _MetaRow(walk),
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
                      child: const Icon(Icons.arrow_forward, size: 20, color: darkBg),
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

/// Обложка маршрута: аватарки остановок, наложенные друг на друга.
class _AvatarStrip extends StatelessWidget {
  const _AvatarStrip(this.stops);

  final List<Landmark> stops;

  static const _size = 76.0;
  static const _step = 54.0;

  @override
  Widget build(BuildContext context) {
    final shown = stops.take(4).toList();
    final width = _size + _step * (shown.length - 1);
    return SizedBox(
      height: 116,
      child: Center(
        child: SizedBox(
          width: width,
          height: _size,
          child: Stack(
            children: [
              for (int i = 0; i < shown.length; i++)
                Positioned(
                  left: i * _step,
                  child: LandmarkAvatar(shown[i], size: _size),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow(this.walk);

  final _Walk walk;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final lang = state.lang;
    final km = walk.km.toStringAsFixed(1);
    final kmText = lang == 2 ? '$km km' : '${km.replaceAll('.', ',')} км';
    final minText = state.t('~${walk.minutes} мин', '~${walk.minutes} мин', '~${walk.minutes} min');
    return Wrap(
      spacing: 14,
      runSpacing: 4,
      children: [
        _Meta(Icons.place_outlined, _countText(walk.landmarkIds.length, lang)),
        _Meta(Icons.route_outlined, kmText),
        _Meta(Icons.schedule, minText),
      ],
    );
  }
}

/// Экран маршрута: остановки по порядку.
class _WalkScreen extends StatelessWidget {
  const _WalkScreen(this.walk);

  final _Walk walk;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;
    final stops = walk.stops;
    return Scaffold(
      appBar: AppBar(title: Text(walk.names[state.lang])),
      body: SafeArea(
        child: PageList(
          children: [
            SectionTitle(walk.names[state.lang]),
            _MetaRow(walk),
            Text(
              t(
                'Длина и время ориентировочные.',
                'Ұзындығы мен уақыты шамамен алынған.',
                'Distance and time are approximate.',
              ),
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
            ),
            for (int i = 0; i < stops.length; i++)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: gold),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(color: darkBg, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: LandmarkCard(stops[i])),
                ],
              ),
          ],
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