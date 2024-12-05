import 'package:flutter/material.dart';

class Suggestion {
  final String title;
  final IconData icon;
  bool selected;

  Suggestion({required this.title, required this.icon, this.selected = false});

  @override
  String toString() {
    return 'Item(title: $title, icon: ${icon.codePoint}, selected: $selected)';
  }
}
