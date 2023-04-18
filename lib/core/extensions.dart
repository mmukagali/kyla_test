import 'package:flutter/material.dart' show Color;

extension StringToColorParser on String {
  Color getColor() {
    try {
      final temp = int.parse(replaceAll('#', 'FF'), radix: 16);
      return Color(temp);
    } on Exception {
      return const Color(0xFFFFFFFF);
    }
  }
}
