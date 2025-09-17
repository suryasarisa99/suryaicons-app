library hugeicons;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuryaIcon extends StatelessWidget {
  final List<List<dynamic>> icon;
  final Color color;
  final double size;
  final double? strokeWidth;
  final double opacity;
  final Color? color2;

  const SuryaIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24.0,
    this.strokeWidth,
    this.opacity = 0.4,
    this.color2,
  });

  // String buildSvgFromJson() {
  //   final buffer = StringBuffer();
  //   buffer.write(
  //     '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">',
  //   );
  //   for (final element in icon) {
  //     final tagName = element[0] as String;
  //     final attributes = element[1] as Map<String, dynamic>;
  //     buffer.write('<$tagName');
  //     for (final entry in attributes.entries) {
  //       final key = entry.key;
  //       final value = entry.value;
  //       if (key == 'key') {
  //         continue;
  //       }
  //       String finalValue = value.toString();
  //       if (key == 'stroke' && value == '_c') {
  //         finalValue =
  //             '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  //       } else if (key == 'fill' && value == '_c') {
  //         finalValue =
  //             '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  //       } else if (key == 'stroke-width' && strokeWidth != null) {
  //         debugPrint("using custom strokeWidth: $strokeWidth");
  //         finalValue = strokeWidth.toString();
  //       }
  //       buffer.write(' $key="$finalValue"');
  //     }
  //     buffer.write('/>');
  //   }
  //   buffer.write('</svg>');
  //   return buffer.toString();
  // }

  String _buildElement(dynamic element) {
    final tagName = element[0] as String;
    final attributes = element[1] as Map<String, dynamic>;
    final children = element.length > 2 ? element[2] as List<dynamic> : null;
    // debugPrint();
    final attrBuffer = StringBuffer();
    for (final entry in attributes.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key == 'key') continue;

      String finalValue = value.toString();
      if ((key == 'stroke' || key == 'fill') &&
          (value == '_c1' || value == '_c2')) {
        if (value == '_c1' || (color2 == null && value == '_c2')) {
          finalValue =
              '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
        } else if (value == '_c2' && color2 != null) {
          finalValue =
              '#${color2!.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
        }
      } else if (key == 'stroke-width' && strokeWidth != null) {
        finalValue = strokeWidth.toString();
      } else if (key == "opacity" && (value == "_o")) {
        finalValue = opacity.toStringAsFixed(2);
      }
      attrBuffer.write(' $key="$finalValue"');
    }

    if (children != null && children.isNotEmpty) {
      final childStr = children.map(_buildElement).join();
      return '<$tagName${attrBuffer.toString()}>$childStr</$tagName>';
    } else {
      return '<$tagName${attrBuffer.toString()}/>';
    }
  }

  String buildSvgFromJson() {
    final buffer = StringBuffer();
    buffer.write(
      '<svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">',
    );

    buffer.writeAll(icon.map(_buildElement));
    buffer.write('</svg>');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final svgString = buildSvgFromJson();
    return SvgPicture.string(svgString, width: size, height: size);
  }
}
