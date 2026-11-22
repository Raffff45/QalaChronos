import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_theme.dart';
import '../../core/routes.dart';
import '../../data/landmark.dart';
import '../../data/landmarks.dart';
import '../../state/app_scope.dart';
import '../../widgets/landmark_avatar.dart';

/// Карта Алматы с метками архитектурных объектов, положением пользователя
/// и подсказкой, если плитки карты не загрузились (нет интернета).
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

  // Геолокация пользователя
  LatLng? _me;
  StreamSubscription<Position>? _posSub;
  bool _locating = false;

  // Загрузка плиток карты
  bool _tilesFailed = false;
  int _tileEpoch = 0;

  @override
  void dispose() {
    _posSub?.cancel();
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
    _moveTo(LatLng(l.lat, l.lng));
  }

  void _moveTo(LatLng point) {
    final zoom = _controller.camera.zoom;
    _controller.move(point, zoom < _focusZoom ? _focusZoom : zoom);
  }

  void _retryTiles() {
    setState(() {
      _tilesFailed = false;
      _tileEpoch++; // новый ключ слоя плиток = повторная загрузка
    });
  }

  void _toast(String text, {String? actionLabel, Future<bool> Function()? action}) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        action: (actionLabel != null && action != null)
            ? SnackBarAction(label: actionLabel, onPressed: () => action())
            : null,
      ),
    );
  }

  /// Определяет положение пользователя, ставит на карту синюю точку
  /// и дальше обновляет её, пока открыта карта.
  Future<void> _goToMe() async {
    if (_locating) return;
    final t = AppScope.read(context).t;
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _toast(
          t(
            'Включите геолокацию на телефоне.',
            'Телефондағы геолокацияны қосыңыз.',
            'Turn on location services on your phone.',
          ),
          actionLabel: t('Настройки', 'Баптаулар', 'Settings'),
          action: Geolocator.openLocationSettings,
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        _toast(t(
          'Нет доступа к геолокации.',
          'Геолокацияға рұқсат жоқ.',
          'Location permission was denied.',
        ));
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        _toast(
          t(
            'Разрешите геолокацию в настройках приложения.',
            'Қолданба баптауларында геолокацияға рұқсат беріңіз.',
            'Allow location in the app settings.',
          ),
          actionLabel: t('Настройки', 'Баптаулар', 'Settings'),
          action: Geolocator.openAppSettings,
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!mounted) return;
      final me = LatLng(pos.latitude, pos.longitude);
      setState(() => _me = me);
      _moveTo(me);
      _startStream();
    } on TimeoutException {
      _toast(t(
        'Не удалось определить местоположение. Выйдите на открытое место и повторите.',
        'Орналасқан жерді анықтау мүмкін болмады. Ашық жерге шығып, қайталаңыз.',
        'Could not get your location. Try again outdoors.',
      ));
    } catch (_) {
      _toast(t(
        'Не удалось определить местоположение.',
        'Орналасқан жерді анықтау мүмкін болмады.',
        'Could not get your location.',
      ));
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _startStream() {
    _posSub?.cancel();
    _posSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15, // обновлять, когда сдвинулись минимум на 15 м
      ),
    ).listen(
      (p) {
        if (mounted) setState(() => _me = LatLng(p.latitude, p.longitude));
      },
      onError: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;
    final selected = _selected;
    final topInset = MediaQuery.paddingOf(context).top;

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
                key: ValueKey(_tileEpoch),
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: _userAgent,
                errorTileCallback: (tile, error, stackTrace) {
                  if (_tilesFailed) return;
                  // setState нельзя вызывать прямо во время построения кадра
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_tilesFailed) {
                      setState(() => _tilesFailed = true);
                    }
                  });
                },
              ),
              if (_me != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _me!,
                      width: 26,
                      height: 26,
                      child: const _MeDot(),
                    ),
                  ],
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
            top: topInset + 12,
            left: 16,
            child: _TitlePill(t('Карта Алматы', 'Алматы картасы', 'Almaty map')),
          ),

        // Нет интернета / плитки не загрузились
        if (_tilesFailed)
          Positioned(
            top: topInset + (widget.showTitle ? 64 : 12),
            left: 16,
            right: 16,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: _OfflineBanner(
                  text: t(
                    'Карта не загрузилась. Проверьте интернет.',
                    'Карта жүктелмеді. Интернетті тексеріңіз.',
                    'Map failed to load. Check your internet connection.',
                  ),
                  retryLabel: t('Повторить', 'Қайталау', 'Retry'),
                  onRetry: _retryTiles,
                ),
              ),
            ),
          ),

        // Кнопка «Где я»
        Positioned(
          right: 16,
          bottom: 140,
          child: _RoundButton(
            icon: Icons.my_location,
            loading: _locating,
            onTap: _goToMe,
          ),
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
                // небольшое увеличение прячет синюю кайму самой аватарки
                child: Transform.scale(
                  scale: 1.12,
                  child: Image.asset(
                    landmark.avatar,
                    fit: BoxFit.cover,
                    cacheWidth: 156,
                  ),
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
                LandmarkAvatar(landmark, size: 64),
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
/// Синяя точка «вы здесь».
class _MeDot extends StatelessWidget {
  const _MeDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2F80ED),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80ED).withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onTap,
    this.loading = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: darkBg.withValues(alpha: 0.92),
      elevation: 3,
      shape: CircleBorder(
        side: BorderSide(color: gold.withValues(alpha: 0.45), width: 1.2),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: loading ? null : onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: gold),
                  )
                : Icon(icon, color: gold),
          ),
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({
    required this.text,
    required this.retryLabel,
    required this.onRetry,
  });

  final String text;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: darkBg.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gold.withValues(alpha: 0.45), width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(retryLabel)),
        ],
      ),
    );
  }
}