import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_theme.dart';
import '../../core/routes.dart';
import '../../data/landmarks.dart';
import '../../state/app_scope.dart';
import '../../widgets/landmark_card.dart';
import '../../widgets/menu_tile.dart';

/// Главная: шапка с горами Алматы, под ней плитки разделов и список объектов.
class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.onSelectTab});

  /// Переключает вкладку нижней навигации (1 = карта, 2 = каталог).
  final ValueChanged<int> onSelectTab;

  // Шапку берём из верхней части menu.png (там логотип, горы, город).
  // Картинка 941x1672, а город с логотипом заканчиваются примерно на 40% высоты.
  static const _headerImage = AssetImage('assets/menu.png');
  static const _imageRatio = 1672 / 941;
  static const _headerShare = 0.42;
  static const _maxContentWidth = 480.0;
  static const _cream = Color(0xFFF2E3BD);

  @override
  Widget build(BuildContext context) {
    final t = AppScope.of(context).t;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // шапка идёт под статус-баром: значки там светлые
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: LayoutBuilder(
            builder: (context, box) {
              final headerHeight = box.maxWidth * _imageRatio * _headerShare;

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  _Header(height: headerHeight),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.3,
                          children: [
                            MenuTile(
                              icon: Icons.location_on_outlined,
                              label: t('Карта\nобъектов', 'Нысандар\nкартасы',
                                  'Landmark\nmap'),
                              onTap: () => onSelectTab(1),
                            ),
                            MenuTile(
                              icon: Icons.view_in_ar_outlined,
                              label: t('3D-модели', '3D-модельдер', '3D models'),
                              onTap: () => openLandmark(context, landmarks.first),
                            ),
                            MenuTile(
                              icon: Icons.history,
                              label: t('Машина\nвремени', 'Уақыт\nмашинасы',
                                  'Time\nmachine'),
                              onTap: () => openTimeMachine(context),
                            ),
                            MenuTile(
                              icon: Icons.explore_outlined,
                              label: t('Каталог', 'Тізім', 'Explore'),
                              onTap: () => onSelectTab(2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Text(
                          t('Объекты', 'Нысандар', 'Landmarks'),
                          style: const TextStyle(
                            color: _cream,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (final l in landmarks) LandmarkCard(l),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // fitWidth + topCenter: показываем верх картинки, нижнюю пустоту обрезаем
          const ClipRect(
            child: Image(
              image: HomeTab._headerImage,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          // плавный переход шапки в фон экрана
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: height * 0.35,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00101C19), darkBg],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}