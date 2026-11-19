# QalaChronos

Образовательный гид по архитектуре Алматы (Flutter).

## Запуск
```
flutter pub get
flutter run
```

## Структура lib/
```
lib/
├── main.dart                  точка входа
├── app.dart                   MaterialApp + тема
├── core/
│   ├── app_theme.dart         цвета и тема
│   └── routes.dart            переходы на экраны объектов
├── data/
│   ├── landmark.dart          модель объекта
│   └── landmarks.dart         список объектов (сюда добавлять новые)
├── state/
│   ├── app_state.dart         язык, избранное, изученное
│   └── app_scope.dart         доступ к состоянию: AppScope.of(context)
├── screens/
│   ├── splash_screen.dart
│   ├── language_screen.dart
│   ├── onboarding_screen.dart
│   ├── main_shell.dart        нижняя навигация
│   ├── tabs/                  home / map / explore / profile
│   ├── landmark_screen.dart   карточка объекта
│   ├── architecture_screen.dart
│   └── time_machine_screen.dart
└── widgets/                   переиспользуемые виджеты
```

Новый объект: добавить `Landmark(...)` в `data/landmarks.dart` и картинку в `assets/`.
