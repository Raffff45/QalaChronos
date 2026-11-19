import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_theme.dart';
import '../../core/routes.dart';
import '../../data/landmark.dart';
import '../../data/landmarks.dart';
import '../../state/app_scope.dart';

/// Карта Алматы с метками архитектурных объектов.
/// [showTitle] = false, когда экран открыт отдельно и заголовок уже есть в AppBar.
class MapTab extends StatefulWidget {
  const MapTab({super.key, this.showTitle = true});

  final bool showTitle;

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  static const _almatyCenter = LatLng(43.2567, 76.9286);
  static const _focusZoom = 15.0;
  static const _maxContentWidth = 480.0;

  // Должен совпадать с applicationId приложения: OSM просит указывать его в запросах.
  static const _userAgent = 'kz.qalachronos.app';

  static final _points = [for (final l in landmarks) LatLng(l.lat, l.lng)];

  final _controller = MapController();
  String? _selectedId = landmarks.isEmpty ? null : landmarks.first.id;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Landmark? get _selected {
    for (final l in landmarks) {
      if (l.id == _selectedId) return l;
    }
    return null;
  }

  void _select(Landmark l) {
    setState(() => _selectedId = l.id);
    final zoom = _controller.camera.zoom;
    _controller.move(
      LatLng(l.lat, l.lng),
      zoom < _focusZoom ? _focusZoom : zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;
    final selected = _selected;

    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            mapController: _controller,
            options: MapOptions(
              initialCenter: _almatyCenter,
              initialZoom: 13,
              // Если объектов несколько, сразу показываем их все
              initialCameraFit: _points.length > 1
                  ? CameraFit.coordinates(
                      coordinates: _points,
                      padding: const EdgeInsets.fromLTRB(64, 120, 64, 180),
                      maxZoom: 16,
                    )
                  : null,
              minZoom: 10,
              maxZoom: 18,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: _userAgent,
              ),
              MarkerLayer(
                markers: [
                  for (final l in landmarks)
                    Marker(
                      point: LatLng(l.lat, l.lng),
                      width: 56,
                      height: 84,
                      // низ метки (остриё) стоит ровно на координате
                      alignment: Alignment.topCenter,
                      child: _Pin(
                        landmark: l,
                        selected: l.id == _selectedId,
                        onTap: () => _select(l),
                      ),
                    ),
                ],
              ),
              RichAttributionWidget(
                alignment: AttributionAlignment.bottomRight,
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                      Uri.parse('https://www.openstreetmap.org/copyright'),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (widget.showTitle)
          Positioned(
            top: MediaQuery.paddingOf(context).top + 12,
            left: 16,
            child: _TitlePill(t('Карта Алматы', 'Алматы картасы', 'Almaty map')),
          ),

        // Карточка выбранного объекта
        if (selected != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 36,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: _SelectedCard(
                  landmark: selected,
                  lang: state.lang,
                  onTap: () => openLandmark(context, selected),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Метка на карте: круглое фото в золотой рамке с «остриём» вниз.
class _Pin extends StatelessWidget {
  const _Pin({
    required this.landmark,
    required this.selected,
    required this.onTap,
  });

  final Landmark landmark;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.2 : 1,
        alignment: Alignment.bottomCenter,
        duration: const Duration(milliseconds: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: darkBg,
                border: Border.all(color: gold, width: selected ? 3 : 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/${landmark.photo}.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -9),
              child: const Icon(Icons.arrow_drop_down, size: 28, color: gold),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitlePill extends StatelessWidget {
  const _TitlePill(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: darkBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold.withValues(alpha: 0.45), width: 1.2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: gold,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SelectedCard extends StatelessWidget {
  const _SelectedCard({
    required this.landmark,
    required this.lang,
    required this.onTap,
  });

  final Landmark landmark;
  final int lang;
  final VoidCallback onTap;

  static const _radius = 22.0;

  @override
  Widget build(BuildContext context) {
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
          border: Border.all(color: gold.withValues(alpha: 0.45), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/${landmark.photo}.jpg',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        landmark.name(lang),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFF2E3BD),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        landmark.year,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: gold),
              ],
            ),
          ),
        ),
      ),
    );
  }
}