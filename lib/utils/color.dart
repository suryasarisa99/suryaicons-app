import 'dart:ui';

extension ColorHex on Color {
  String toHex({bool leadingHashSign = true, bool includeAlpha = false}) {
    late final String x;
    if (includeAlpha) {
      x = toARGB32().toRadixString(16).padLeft(8, '0');
    } else {
      x = toARGB32().toRadixString(16).padLeft(6, '0').substring(2);
    }
    return leadingHashSign ? '#$x'.toUpperCase() : x.toUpperCase();
  }
}
