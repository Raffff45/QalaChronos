import 'package:flutter/widgets.dart';

import 'app_state.dart';

/// Даёт любому виджету доступ к AppState: `AppScope.of(context)`.
/// Виджет, вызвавший `of`, сам перестроится при изменении состояния.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    return scope!.notifier!;
  }

  /// Для обработчиков и отложенных вызовов: без подписки на изменения.
  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    return scope!.notifier!;
  }
}
