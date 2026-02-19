import 'package:flutter/material.dart';

extension ColorOpacityX on Color {
  Color applyOpacity(double value) {
    return withValues(alpha: (value * 255).roundToDouble());
  }
}
