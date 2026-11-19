import 'package:flutter/material.dart';

import '../core/app_theme.dart';

/// Золотая градиентная кнопка (как в онбординге).
/// [onTap] = null делает кнопку неактивной: она бледнеет и не нажимается.
class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onTap,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool showArrow;

  static const _radius = 27.0;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return AnimatedOpacity(
      opacity: enabled ? 1 : 0.4,
      duration: const Duration(milliseconds: 200),
      child: Material(
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
                color: Colors.black.withValues(alpha: 0.35),
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
      ),
    );
  }
}