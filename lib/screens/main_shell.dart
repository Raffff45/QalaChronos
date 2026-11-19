import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import 'tabs/favorites_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/profile_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  void _selectTab(int index) {
    setState(() {
      _tab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppScope.of(context).t;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _tab,
          children: const [
            HomeTab(),
            FavoritesTab(),
            ProfileTab(),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _selectTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: t('Главная', 'Басты', 'Home'),
          ),

          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: t('Избранное', 'Таңдаулы', 'Favorites'),
          ),

          NavigationDestination(
            icon: const Icon(Icons.account_circle_outlined),
            selectedIcon: const Icon(Icons.account_circle),
            label: t('Профиль', 'Профиль', 'Profile'),
          ),
        ],
      ),
    );
  }
}