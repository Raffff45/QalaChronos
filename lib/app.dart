import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/language_screen.dart';
import 'state/app_scope.dart';
import 'state/app_state.dart';

class QalaApp extends StatelessWidget {
  const QalaApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QalaChronos',
        theme: buildAppTheme(),
        // Пока идёт разработка: язык спрашиваем при каждом запуске.
        // Чтобы вернуть «один раз»: state.langChosen ? const SplashScreen() : const LanguageScreen()
        home: const LanguageScreen(),
      ),
    );
  }
}