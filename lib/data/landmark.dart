/// Один архитектурный объект. Тексты хранятся в порядке: ru, kk, en.
class Landmark {
  const Landmark({
    required this.id,
    required this.names,
    required this.descriptions,
    required this.year,
    required this.photo,
    required this.modelPhoto,
    required this.lat,
    required this.lng,
    this.hasThenNow = false,
  });

  final String id;
  final List<String> names;
  final List<String> descriptions;
  final String year;

  /// Имя файла в assets/ без расширения.
  final String photo;
  final String modelPhoto;

  /// Координаты объекта на карте (широта и долгота).
  final double lat;
  final double lng;

  /// Есть ли для объекта сравнение «раньше и сейчас».
  final bool hasThenNow;

  String name(int lang) => names[lang];
  String description(int lang) => descriptions[lang];
}