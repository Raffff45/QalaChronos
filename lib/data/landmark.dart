/// Один архитектурный объект. Тексты хранятся в порядке: ru, kk, en.
class Landmark {
  const Landmark({
    required this.id,
    required this.names,
    required this.descriptions,
    required this.year,
    required this.photo,
    required this.modelPhoto,
    required this.mapX,
    required this.mapY,
    this.hasThenNow = false,
  });

  final String id;
  final List<String> names;
  final List<String> descriptions;
  final String year;

  /// Имя файла в assets/ без расширения.
  final String photo;
  final String modelPhoto;

  /// Положение метки на схематичной карте (доля ширины / высоты).
  final double mapX;
  final double mapY;

  /// Есть ли для объекта сравнение «раньше и сейчас».
  final bool hasThenNow;

  String name(int lang) => names[lang];
  String description(int lang) => descriptions[lang];
}
