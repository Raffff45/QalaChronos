import 'package:flutter/material.dart';

import '../../data/landmarks.dart';
import '../../state/app_scope.dart';
import '../../widgets/landmark_card.dart';
import '../../widgets/page_list.dart';
import '../../widgets/section_title.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;
    final q = _query.toLowerCase();
    return PageList(
      children: [
        SectionTitle(t('Каталог', 'Тізім', 'Explore')),
        TextField(
          onChanged: (s) => setState(() => _query = s),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: t('Поиск', 'Іздеу', 'Search'),
          ),
        ),
        for (final l in landmarks)
          if (l.name(state.lang).toLowerCase().contains(q)) LandmarkCard(l),
      ],
    );
  }
}
