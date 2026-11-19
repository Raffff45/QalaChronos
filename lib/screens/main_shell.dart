import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import 'tabs/explore_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/map_tab.dart';
import 'tabs/profile_tab.dart';

/// Главный экран с нижней навигацией.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  void _selectTab(int index) => setState(() => _tab = index);

  @override
  Widget build(BuildContext context) {
    final t = AppScope.of(context).t;
    return Scaffold(
      // top: false: шапка главной уходит под статус-бар, остальные вкладки
      // получают верхний отступ в PageList
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _tab,
          children: [
            HomeTab(onSelectTab: _selectTab),
            const MapTab(),
            const ExploreTab(),
            const ProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _selectTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: t('Главная', 'Басты', 'Home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            label: t('Карта', 'Карта', 'Map'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            label: t('Каталог', 'Тізім', 'Explore'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            label: t('Профиль', 'Профиль', 'Profile'),
          ),
        ],
      ),
    );
  }
}