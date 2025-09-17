import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:suryaicons_app/widgets/popup_surface.dart';

showColorPicker(
  BuildContext context,
  Color color,
  Function(Color) pickColor, {
  Alignment alignment = Alignment.center,
  double? alpha,
}) {
  final enableAlpha = alpha != null;
  // alpha + color
  final actualColor = alpha != null ? color.withValues(alpha: alpha) : color;

  showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) => PopupSurface(
      width: 700,
      alignment: alignment,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: ColorPicker(
              colorPickerWidth: 240,
              paletteType: PaletteType.hueWheel,
              enableAlpha: enableAlpha,
              pickerColor: actualColor,
              onColorChanged: pickColor,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    pickColor(Color(0xffF13583));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Reset"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
