import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_theme.dart';
import '../state/app_scope.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  /// [replay] = true, когда экран открыт из профиля: после прохождения закрываем.
  const OnboardingScreen({super.key, this.replay = false});

  final bool replay;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Заголовки и подписи уже нарисованы в самих картинках.
  static const _pages = [
    AssetImage('assets/onbording_1.png'),
    AssetImage('assets/onbording_2.png'),
    AssetImage('assets/onbording_3.png'),
  ];

  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == _pages.length - 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final p in _pages) {
      precacheImage(p, context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    AppScope.read(context).finishIntro();
    if (widget.replay) {
      Navigator.pop(context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const MainShell(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
        (_) => false,
      );
    }
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppScope.of(context).t;
    final size = MediaQuery.sizeOf(context);
    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: darkBg,
      ),
      child: Scaffold(
        backgroundColor: darkBg,
        body: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => SizedBox.expand(
                child: Image(image: _pages[i], fit: BoxFit.cover),
              ),
            ),

            // «Пропустить» — над золотой рамкой, чтобы не наезжать на неё
            Positioned(
              top: topInset + 2,
              right: size.width * 0.06,
              child: TextButton(
                onPressed: _finish,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white.withOpacity(0.75),
                  textStyle: const TextStyle(fontSize: 14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(t('Пропустить', 'Өткізу', 'Skip')),
              ),
            ),

            // Точки (как на макете: ~84% высоты)
            Positioned(
              left: 0,
              right: 0,
              top: size.height * 0.84 - 4,
              child: _Dots(count: _pages.length, current: _page),
            ),

            // Кнопка (как на макете: центр ~91.5% высоты)
            Positioned(
              left: size.width * 0.115,
              right: size.width * 0.115,
              top: size.height * 0.915 - 27,
              child: _GoldButton(
                label: _isLast
                    ? t('Начать', 'Бастау', 'Start')
                    : t('Далее', 'Келесі', 'Next'),
                showArrow: !_isLast,
                onTap: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == current
                  ? const Color(0xFFF2E3BD)
                  : Colors.white.withOpacity(0.25),
            ),
          ),
      ],
    );
  }
}

class _GoldButton extends StatelessWidget {
  const _GoldButton({
    required this.label,
    required this.onTap,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool showArrow;

  static const _radius = 27.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD8BF86), Color(0xFFB8975A)],
          ),
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: darkBg,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (showArrow) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 19, color: darkBg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}