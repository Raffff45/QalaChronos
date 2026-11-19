import 'package:flutter/material.dart';

import '../../data/landmarks.dart';
import '../../state/app_scope.dart';
import '../../widgets/page_list.dart';
import '../../widgets/section_title.dart';
import '../../widgets/wide_button.dart';
import '../language_screen.dart';
import '../onboarding_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = state.t;
    final seenCount = landmarks.where((l) => state.isSeen(l.id)).length;

    return PageList(
      children: [
        SectionTitle(t('Профиль', 'Профиль', 'Profile')),
        Text('$seenCount / ${landmarks.length}'),
        LinearProgressIndicator(value: seenCount / landmarks.length),
        WideButton(
          t('Изменить язык', 'Тілді өзгерту', 'Change language'),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LanguageScreen(popAfter: true)),
          ),
        ),
        WideButton(
          t('Повторить знакомство', 'Қайта танысу', 'Repeat onboarding'),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen(replay: true)),
          ),
        ),
      ],
    );
  }
}
