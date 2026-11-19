import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  const WideButton(this.label, this.onPressed, {super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(label),
        ),
      ),
    );
  }
}
