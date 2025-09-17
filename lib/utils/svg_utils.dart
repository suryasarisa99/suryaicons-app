class SvgUtils {
  static const keys = [
    "stroke-width",
    "stroke-linecap",
    "stroke-linejoin",
    "fill-rule",
    "clip-rule",
  ];

  static bool supportsColor2(int variant) {
    return variant <= 2;
  }

  static bool supportsStrokeWidth(int variant) {
    return variant > 0 && variant < 6;
  }

  // for only react using variable name opacity2, because opacity is already in propsType
  static String reactComponent(
    List<List<dynamic>> icon,
    String colorHex, {
    double? strokeWidth,
    required int variant,
  }) {
    final buffer = StringBuffer();
    buffer.write(
      'const DocumentAttachmentIcon = (\nprops: React.SVGProps<SVGSVGElement> & { size?: string | number',
    );
    if (supportsColor2(variant)) {
      buffer.write(', color2?: string, opacity2?: number');
    }
    buffer.write(' }\n) => {\n');
    buffer.write('  const color = props.color || "$colorHex";\n');
    if (supportsColor2(variant)) {
      buffer.write('  const color2 = props.color2 || color;\n');
    }
    buffer.write('  return (\n');
    final svg = BuildSvg(
      icon: icon,
      color: 'color',
      color2: 'color2',
      opacity: 'props.opacity2 || 0.4',
      strokeWidth: 'props.strokeWidth',
      size: 'props.size || 48',
      generateVariable: (v) => '{$v}',
      indentationStart: 2,
      useCamelCase: true,
      additional: '{...props}',
    ).run();
    buffer.write(svg);
    buffer.write('  );');
    buffer.write('\n};\n');
    return buffer.toString();
  }

  static String flutterWidget(
    List<List<dynamic>> icon,
    String colorHex, {
    double? strokeWidth,
    required int variant,
  }) {
    final buffer = StringBuffer();
    const className = "DocumentAttachmentIcon";
    final hexaClr = '0xFF${colorHex.substring(1)}';
    buffer.write("import 'package:flutter/material.dart';\n");
    buffer.write("import 'package:flutter_svg/flutter_svg.dart';\n\n");
    buffer.write('class $className extends StatelessWidget {\n');
    buffer.write('  final Color color;\n');
    buffer.write('  final double size;\n');
    if (supportsColor2(variant)) {
      buffer.write('  final Color? color2;\n');
      buffer.write('  final double? opacity;\n');
    }
    if (supportsStrokeWidth(variant)) {
      buffer.write('  final double strokeWidth;\n');
    }
    buffer.write('  const $className({\n');
    buffer.write('    super.key,\n');
    buffer.write('    this.color = const Color($hexaClr),\n');
    buffer.write('    this.size = 24.0,\n');
    if (supportsColor2(variant)) {
      buffer.write('    this.color2,\n');
      buffer.write('    this.opacity = 16.0,\n');
    }
    if (supportsStrokeWidth(variant)) {
      buffer.write('    this.strokeWidth = 1.5,\n');
    }
    buffer.write('  });\n\n');
    buffer.write('  String _colorToHex(Color c) =>\n');
    buffer.write(
      "      '#\${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';\n\n",
    );
    buffer.write('  @override\n');
    buffer.write('  Widget build(BuildContext context) {\n');
    buffer.write('    final svgString = \'\'\'\n');
    buffer.write(
      BuildSvg(
        icon: icon,
        color: "{_colorToHex(color)}",
        color2: "{_colorToHex(color2 ?? color)}",
        size: "size",
        opacity: "opacity",
        generateVariable: (v) => '"\$$v"',
        indentationStart: 4,
        strokeWidth: "strokeWidth",
        useCamelCase: false,
      ).run(),
    );
    buffer.write('\'\'\';\n');
    buffer.write(
      '    return SvgPicture.string(svgString, width: size, height: size);\n',
    );
    buffer.write('  }\n');
    buffer.write('}\n');
    return buffer.toString();
  }

  static String angularComponent(
    List<List<dynamic>> icon,
    String colorHex, {
    double? strokeWidth,
    required int variant,
  }) {
    final buffer = StringBuffer();
    buffer.write("import { Component, Input } from '@angular/core';\n\n");
    buffer.write('@Component({\n');
    buffer.write("  selector: 'app-document-attachment-icon',\n");
    buffer.write("  template: `\n");
    buffer.write(
      BuildSvg(
        icon: icon,
        color: 'color',
        color2: 'color2',
        opacity: 'opacity',
        strokeWidth: 'strokeWidth',
        size: 'size',
        generateVariable: (v) => '{{${v}}}',
        indentationStart: 2,
        useCamelCase: false,
      ).run(),
    );
    buffer.write("  `,\n");
    buffer.write('})\n');
    buffer.write('export class DocumentAttachmentIconComponent {\n');

    buffer.write('  @Input() color: string = "$colorHex";\n');
    buffer.write('  @Input() size: number = 24;\n');
    if (supportsColor2(variant)) {
      buffer.write('  @Input() color2: string = this.color;\n');
      buffer.write('  @Input() opacity: number = 0.4;\n');
    }
    if (supportsStrokeWidth(variant)) {
      buffer.write('  @Input() strokeWidth: number = 1.5;\n');
    }
    buffer.write('}\n');
    return buffer.toString();
  }

  static String svelteComponent(
    List<List<dynamic>> icon,
    String colorHex, {
    String? color2,
    double? opacity = 0.4,
    double? strokeWidth,
    required int variant,
  }) {
    final buffer = StringBuffer();
    buffer.write('<script>\n');
    buffer.write("  export let color = '$colorHex';\n");
    buffer.write('  export let size = 24;\n');
    if (supportsStrokeWidth(variant)) {
      buffer.write('  export let strokeWidth = 1.5;\n');
    }
    if (supportsColor2(variant)) {
      buffer.write('  export let opacity = $opacity;\n');
      buffer.write('  export let color2 = color;\n');
    }
    buffer.write('</script>\n\n');

    buffer.write(
      BuildSvg(
        icon: icon,
        color: 'color',
        color2: 'color2',
        opacity: 'opacity',
        strokeWidth: 'strokeWidth',
        size: 'size',
        generateVariable: (v) => '{$v}',
        indentationStart: 0,
        useCamelCase: true,
        additional: '{...\$props}', // pass all props
      ).run(),
    );

    return buffer.toString();
  }

  static String vueComponent(
    List<List<dynamic>> icon,
    String colorHex, {
    double? strokeWidth,
    required int variant,
  }) {
    final buffer = StringBuffer();
    buffer.write('<script setup lang="ts">\n');
    // buffer.write(
    //   'defineProps<{ color?: string; size?: number; strokeWidth?: number }>();\n',
    // );
    buffer.write('const props = defineProps<{ color?: string; size?: number');
    if (supportsStrokeWidth(variant)) {
      buffer.write('; strokeWidth?: number');
    }
    if (supportsColor2(variant)) {
      buffer.write('; color2?: string; opacity?: number');
    }
    buffer.write(' }>();\n');

    buffer.write('</script>\n\n');
    buffer.write('<template>\n');
    buffer.write(
      BuildSvg(
        icon: icon,
        color: 'color || "$colorHex"',
        color2: 'color2 || color',
        opacity: 'opacity || 0.4',
        strokeWidth: 'strokeWidth || 1.5',
        size: 'size || 24',
        generateVariable: (v) => ':{${v}}',
        indentationStart: 0,
        useCamelCase: false,
      ).run(),
    );
    buffer.write('\n</template>\n');
    return buffer.toString();
  }
}

class BuildSvg {
  final List<List<dynamic>> icon;
  final String size;
  final String color;
  final String? color2;
  final String? opacity;
  final String? strokeWidth;
  final bool useCamelCase;
  final String? additional;
  final int indentationStart;
  final int indentationSpaces;

  final String Function(String v) generateVariable;

  BuildSvg({
    required this.icon,
    required this.size,
    required this.color,
    this.strokeWidth,
    required this.generateVariable,
    required this.useCamelCase,
    this.additional,
    required this.indentationStart,
    this.indentationSpaces = 2,
    this.color2,
    this.opacity = "0.4",
  });

  String run() {
    final buffer = StringBuffer();
    final spaces = " " * indentationStart * indentationSpaces;
    buffer.write(
      '$spaces<svg width=${generateVariable(size)} height=${generateVariable(size)} viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" ',
    );
    if (additional != null) buffer.write('${additional!} ');
    buffer.write('>');

    buffer.writeAll(icon.map((e) => _buildElement(e, indentationStart + 1)));
    buffer.write('\n$spaces</svg>');
    return buffer.toString();
  }

  String _buildElement(dynamic element, int indentationStart) {
    final spaces = " " * indentationStart * indentationSpaces;
    final tagName = element[0] as String;
    final attributes = element[1] as Map<String, dynamic>;
    final children = element.length > 2 ? element[2] as List<dynamic> : null;

    final attrBuffer = StringBuffer();
    for (final entry in attributes.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key == 'key') continue;
      bool useGneratedFn = false;

      String finalValue = value.toString();
      if ((key == 'stroke' || key == 'fill')) {
        if (value == '_c1' || (color2 == null && value == '_c2')) {
          finalValue = generateVariable(color);
          useGneratedFn = true;
        } else if (value == '_c2' && color2 != null) {
          finalValue = generateVariable(color2!);
          useGneratedFn = true;
        }
      } else if (key == 'stroke-width' && strokeWidth != null) {
        finalValue = generateVariable(strokeWidth!);
        useGneratedFn = true;
      } else if (key == "opacity" && (value == "_o")) {
        finalValue = generateVariable(opacity.toString());
        useGneratedFn = true;
      }
      late String finalKey;
      if (useCamelCase && keys.contains(key)) {
        finalKey = capcaseKey(key);
      } else {
        finalKey = key;
      }
      if (useGneratedFn) {
        attrBuffer.write(' $finalKey=$finalValue');
      } else {
        attrBuffer.write(' $finalKey="$finalValue"');
      }
    }

    if (children != null && children.isNotEmpty) {
      final childStr = children
          .map((e) => _buildElement(e, indentationStart + 1))
          .join();
      return '\n$spaces<$tagName${attrBuffer.toString()}>$childStr</$tagName>';
    } else {
      return '\n$spaces<$tagName${attrBuffer.toString()}/>';
    }
  }

  static const keys = [
    "stroke-width",
    "stroke-linecap",
    "stroke-linejoin",
    "fill-rule",
    "clip-rule",
  ];

  static String capcaseKey(String key) {
    final parts = key.split('-');
    return parts[0] +
        parts.sublist(1).map((e) => e[0].toUpperCase() + e.substring(1)).join();
  }
}
