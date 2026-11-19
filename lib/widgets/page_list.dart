import 'package:flutter/material.dart';

/// Прокручиваемый список с одинаковыми отступами между элементами.
class PageList extends StatelessWidget {
  const PageList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        20,
        20 + MediaQuery.paddingOf(context).top,
        20,
        20,
      ),
      children: [
        for (final w in children) ...[w, const SizedBox(height: 16)],
      ],
    );
  }
}