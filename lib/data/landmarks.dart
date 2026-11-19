import 'landmark.dart';

const landmarks = <Landmark>[
  Landmark(
    id: 'cathedral',
    names: ['Вознесенский собор', 'Вознесение кафедралы', 'Ascension Cathedral'],
    descriptions: [
      'Деревянный собор в парке имени 28 гвардейцев-панфиловцев.',
      '28 панфиловшылар саябағындағы ағаш собор.',
      'A wooden cathedral in the Park of 28 Panfilov Guardsmen.',
    ],
    year: '1907',
    photo: 'cathedral',
    modelPhoto: 'model',
    lat: 43.2588,
    lng: 76.9567,
    hasThenNow: true,
  ),
  Landmark(
    id: 'theatre',
    names: ['Театр имени Абая', 'Абай театры', 'Abay Opera Theatre'],
    descriptions: [
      'Историческое здание оперного театра Алматы.',
      'Алматының тарихи опера театры.',
      'Historic opera theatre in Almaty.',
    ],
    year: '1941',
    photo: 'theatre',
    modelPhoto: 'theatre',
    lat: 43.2494,
    lng: 76.9458,
  ),
];