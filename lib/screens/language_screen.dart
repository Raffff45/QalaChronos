// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qalachronos/widgets/Gold%20button.dart';

import '../core/app_theme.dart';
import '../state/app_scope.dart';
import 'splash_screen.dart';

/// Первый экран приложения: выбор языка поверх картинки menu.png.
/// От выбранного языка зависит всё дальнейшее: сплэш, онбординг, интерфейс.
class LanguageScreen extends StatefulWidget {
  /// [popAfter] = true, когда экран открыт из профиля: после выбора просто закрываем.
  const LanguageScreen({super.key, this.popAfter = false});

  final bool popAfter;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const _background = AssetImage('assets/menu.png');

  // Размер menu.png и доля высоты, где заканчивается город и начинается пустое поле.
  static const _imageRatio = 1672 / 941;
  static const _maxContentWidth = 480.0;
  static const _emptyStartsAt = 0.40;

  // Цвет нижней части картинки, чтобы она бесшовно переходила в фон экрана.
  static const _bottomBg = Color(0xFF01231C);
  static const _cream = Color(0xFFF2E3BD);

  // Порядок на экране: казахский, русский, английский.
  // id должен совпадать с AppState.lang: 0 = русский, 1 = қазақша, 2 = English.
  static const _languages = [
    _Language(1, 'KZ', 'Қазақша'),
    _Language(0, 'RU', 'Русский'),
    _Language(2, 'EN', 'English'),
  ];

  // Текст кнопки «Продолжить» на языке, который сейчас выбран (ключ = id языка).
  static const _continueLabels = {
    0: 'Продолжить',
    1: 'Жалғастыру',
    2: 'Continue',
  };

  bool _ready = false;
  bool _started = false;

  /// id выбранного языка. null = ещё ничего не выбрано, кнопка неактивна.
  /// В AppState язык пишем только после нажатия «Продолжить».
  int? _selected;

  @override
  void initState() {
    super.initState();
    // Из профиля сразу показываем текущий язык выбранным
    if (widget.popAfter) _selected = AppScope.read(context).lang;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    precacheImage(_background, context).then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  void _confirm() {
    final langId = _selected;
    if (langId == null) return;

    AppScope.read(context).setLang(langId);
    if (widget.popAfter) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const SplashScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _bottomBg,
      ),
      child: Scaffold(
        backgroundColor: _bottomBg,
        body: AnimatedOpacity(
          opacity: _ready ? 1 : 0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          // На широких окнах (десктоп, планшет) держим «телефонную» колонку по центру,
          // иначе картинка растягивается по ширине и кнопки уезжают за нижний край.
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: LayoutBuilder(
                builder: (context, box) =>
                    _buildContent(context, box.maxWidth),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double width) {
    final imageHeight = width * _imageRatio;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image(
            image: _background,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),

        // Заголовок и кнопки в пустой части картинки
        Positioned.fill(
          top: imageHeight * _emptyStartsAt,
          child: SafeArea(
            top: false,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.115),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Тілді таңдаңыз',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _cream,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Выберите язык · Choose language',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 28),
                    for (int i = 0; i < _languages.length; i++) ...[
                      _LanguageTile(
                        language: _languages[i],
                        selected: _languages[i].id == _selected,
                        onTap: () =>
                            setState(() => _selected = _languages[i].id),
                      ),
                      if (i != _languages.length - 1) const SizedBox(height: 14),
                    ],
                    const SizedBox(height: 28),
                    GoldButton(
                      // до выбора языка кнопка бледная и не нажимается
                      label: _continueLabels[_selected ?? 1]!,
                      showArrow: true,
                      onTap: _selected == null ? null : _confirm,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Кнопка «назад» только когда экран открыт из профиля
        if (widget.popAfter)
          Positioned(
            top: MediaQuery.paddingOf(context).top + 4,
            left: 8,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: _cream),
            ),
          ),
      ],
    );
  }
}

class _Language {
  const _Language(this.id, this.code, this.name);

  final int id;
  final String code;
  final String name;
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final _Language language;
  final bool selected;
  final VoidCallback onTap;

  static const _radius = 30.0;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? darkBg : const Color(0xFFF2E3BD);

    return Material(
      color: Colors.transparent,
      child: Ink(
        height: 60,
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFD8BF86), Color(0xFFB8975A)],
                )
              : null,
          color: selected ? null : const Color(0xCC12332A),
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(
            color: gold.withValues(alpha: selected ? 1 : 0.45),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    language.code,
                    style: TextStyle(
                      color: selected ? darkBg : gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    language.name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: selected
                      ? const Icon(
                          Icons.check_circle,
                          key: ValueKey('on'),
                          size: 24,
                          color: darkBg,
                        )
                      : Icon(
                          Icons.radio_button_unchecked,
                          key: const ValueKey('off'),
                          size: 24,
                          color: gold.withValues(alpha: 0.6),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}