import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_theme.dart';
import '../../core/routes.dart';
import '../../state/app_scope.dart';
import '../../widgets/menu_tile.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static const _headerImage = AssetImage('assets/menu.png');
  static const _imageRatio = 1672 / 941;
  static const _headerShare = 0.42;
  static const _maxContentWidth = 480.0;

  @override
  Widget build(BuildContext context) {
    final t = AppScope.of(context).t;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: _maxContentWidth,
          ),
          child: LayoutBuilder(
            builder: (context, box) {
              final headerHeight =
                  box.maxWidth * _imageRatio * _headerShare;

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  _Header(height: headerHeight),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.3,
                      children: [
                        // Карта объектов
                        MenuTile(
                          icon: Icons.location_on_outlined,
                          label: t(
                            'Карта\nобъектов',
                            'Нысандар\nкартасы',
                            'Landmark\nmap',
                          ),
                          onTap: () => openMap(context),
                        ),

                        // 3D-модели
                        MenuTile(
                          icon: Icons.view_in_ar_outlined,
                          label: t(
                            '3D-модели',
                            '3D-модельдер',
                            '3D models',
                          ),
                          onTap: () => openModels(context),
                        ),

                        // Машина времени
                        MenuTile(
                          icon: Icons.history,
                          label: t(
                            'Машина\nвремени',
                            'Уақыт\nмашинасы',
                            'Time\nmachine',
                          ),
                          onTap: () => openTimeMachine(context),
                        ),

                        // Маршруты
                        MenuTile(
                          icon: Icons.route_outlined,
                          label: t(
                            'Маршруты',
                            'Маршруттар',
                            'Routes',
                          ),
                          onTap: () => openRoutes(context),
                        ),
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
          const ClipRect(
            child: Image(
              image: HomeTab._headerImage,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),

          // Плавный переход изображения в фон
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
                  colors: [
                    Color(0x00101C19),
                    darkBg,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}