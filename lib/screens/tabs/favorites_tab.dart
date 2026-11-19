import 'package:flutter/material.dart';

import '../../data/landmarks.dart';
import '../../state/app_scope.dart';
import '../../widgets/landmark_card.dart';
import '../../widgets/page_list.dart';
import '../../widgets/section_title.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;
    final favorites = landmarks.where((l) => state.isFav(l.id)).toList();

    return PageList(
      children: [
        SectionTitle(t('Избранное', 'Таңдаулы', 'Favorites')),
        if (favorites.isEmpty)
          Text(t(
            'Пока пусто. Откройте объект и нажмите «В избранное».',
            'Әзірге бос. Нысанды ашып, «Таңдаулыға» басыңыз.',
            'Nothing here yet. Open a landmark and tap “Favorite”.',
          )),
        for (final l in favorites) LandmarkCard(l),
      ],
    );
  }
}
