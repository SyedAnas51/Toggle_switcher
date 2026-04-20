import 'package:flutter/widgets.dart';

class GCalToggleTab {
  const GCalToggleTab({
    required this.icon,
    required this.page,
    this.label,
    this.tooltip = '',
  });

  final IconData icon;
  final String? label;
  final String tooltip;
  final Widget page;
}