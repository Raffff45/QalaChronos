/// Один архитектурный объект. Тексты хранятся в порядке: ru, kk, en.
class Landmark {
  const Landmark({
    required this.id,
    required this.names,
    required this.descriptions,
    required this.year,
    required this.avatar,
    required this.model,
    required this.lat,
    required this.lng,
    this.hasThenNow = false,
  });

  final String id;
  final List<String> names;
  final List<String> descriptions;

  /// Год завершения строительства.
  final String year;

  /// Круглая аватарка (метка на карте, карточки): путь вида assets/avatar/xxx.png
  final String avatar;

  /// 3D-модель: путь вида assets/3D_models/xxx.glb
  final String model;

  /// Координаты объекта на карте (широта и долгота).
  final double lat;
  final double lng;

  /// Есть ли для объекта сравнение «раньше и сейчас».
  final bool hasThenNow;

  String name(int lang) => names[lang];
  String description(int lang) => descriptions[lang];
}