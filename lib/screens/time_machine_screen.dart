import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../state/app_scope.dart';
import '../widgets/compare_clip.dart';
import '../widgets/page_list.dart';
import '../widgets/section_title.dart';

class TimeMachineScreen extends StatefulWidget {
  const TimeMachineScreen({super.key});

  @override
  State<TimeMachineScreen> createState() => _TimeMachineScreenState();
}

class _TimeMachineScreenState extends State<TimeMachineScreen> {
  double _split = 0.5;

  @override
  Widget build(BuildContext context) {
    final t = AppScope.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('Машина времени', 'Уақыт машинасы', 'Time machine')),
      ),
      body: SafeArea(
        child: PageList(
          children: [
            SectionTitle(t('Раньше и сейчас', 'Бұрын және қазір', 'Then and now')),
            LayoutBuilder(
              builder: (context, box) => SizedBox(
                height: 330,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset('assets/present.jpg', fit: BoxFit.fill),
                    ),
                    Positioned.fill(
                      child: ClipRect(
                        clipper: CompareClipper(_split),
                        child: Image.asset('assets/past.jpg', fit: BoxFit.fill),
                      ),
                    ),
                    Positioned(
                      left: (box.maxWidth - 2) * _split,
                      top: 0,
                      bottom: 0,
                      child: Container(width: 2, color: gold),
                    ),
                  ],
                ),
              ),
            ),
            Slider(
              value: _split,
              onChanged: (v) => setState(() => _split = v),
            ),
            Text(t(
              'Иллюстративная реконструкция, не архивные снимки.',
              'Көрнекі реконструкция, мұрағат суреті емес.',
              'Illustrative reconstruction, not archival photos.',
            )),
          ],
        ),
      ),
    );
  }
}
