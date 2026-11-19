import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_theme.dart';
import '../state/app_scope.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _background = AssetImage('assets/ecran_zagruzki.png');
  static const _loadingTime = Duration(milliseconds: 2400);
  static const _holdAtEnd = Duration(milliseconds: 250);

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: _loadingTime);
  late final Animation<double> _progress =
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);

  bool _started = false;
  bool _ready = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _start();
  }

  Future<void> _start() async {
    await precacheImage(_background, context);
    if (!mounted) return;
    setState(() => _ready = true);

    await _controller.forward();
    await Future.delayed(_holdAtEnd);
    if (!mounted) return;
    _openNext();
  }

  void _openNext() {
    final introDone = AppScope.read(context).introDone;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) =>
            introDone ? const MainShell() : const OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: darkBg,
      ),
      child: Scaffold(
        backgroundColor: darkBg,
        body: AnimatedOpacity(
          opacity: _ready ? 1 : 0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const Image(image: _background, fit: BoxFit.cover),
              Positioned(
                left: size.width * 0.215,
                right: size.width * 0.215,
                bottom: size.height * 0.09,
                child: _ProgressBar(progress: _progress),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final Animation<double> progress;

  static const _height = 6.0;
  static const _track = Color(0x38FFFFFF);
  static const _fillLight = Color(0xFFE9D6A6);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_height),
      child: SizedBox(
        height: _height,
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: _track)),
            AnimatedBuilder(
              animation: progress,
              builder: (_, __) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.value,
                heightFactor: 1,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [_fillLight, gold]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}