import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suryaicons/bulk_rounded.dart';
import 'package:suryaicons/suryaicons.dart';
import 'package:suryaicons/twotone_rounded.dart';
import 'package:suryaicons_app/screens/home.dart';
import 'package:suryaicons_app/utils/camel_case.dart';
import 'package:suryaicons_app/utils/color.dart';
import 'package:suryaicons_app/utils/options.dart';
import 'package:suryaicons_app/utils/search.dart';
import 'package:suryaicons_app/utils/svg_utils.dart';
import 'package:suryaicons_app/widgets/popup_surface.dart';
import 'package:suryaicons_app/widgets/color_popup_editor.dart';

import 'package:flutter_popup/flutter_popup.dart';

class IconEditor extends StatefulWidget {
  const IconEditor({
    super.key,
    required this.iconIndex,
    required this.variantIndex,
    this.color = const Color(0xffF13583),
  });
  final int iconIndex;
  final int variantIndex;
  final Color color;

  @override
  State<IconEditor> createState() => _IconEditorState();
}

class _IconEditorState extends State<IconEditor> {
  late Color iconColor = widget.color;
  late Color secondColor = iconColor;
  // final GlobalKey<CustomPopupState> _keyPickerKey1 = GlobalKey();
  final GlobalKey<CustomPopupState> _keyPickerKey2 = GlobalKey();
  double opacity = 0.4;
  double strokeWidth = 1.5;
  String copyType = Options.copyType;
  String downloadType = "Svg";
  late int variantIndex = widget.variantIndex;

  handleColorPicker(int which) {
    showColorPicker(
      context,
      which == 1 ? iconColor : secondColor,
      alpha: which == 1 ? null : opacity,
      (color) {
        setState(() {
          if (which == 1) {
            iconColor = color;
            secondColor = color;
          } else {
            secondColor = color;
            // get opacity from 0 to 1
            opacity = color.a;
          }
        });
      },
      alignment: Alignment(0, 0.5),
    );
  }

  String getText(String value) {
    final icon = iconSets[variantIndex][widget.iconIndex];
    final name = SearchManager.dataset![widget.iconIndex]['n'] as String;
    if (value == "Svg") {
      return SuryaIcon(
        color2: secondColor,
        icon: icon,
        color: iconColor,
        size: 16,
        strokeWidth: strokeWidth,
      ).buildSvgFromJson();
    } else if (value == "React Code") {
      return SvgUtils.reactComponent(
        icon,
        iconColor.toHex(),
        variant: variantIndex,
        name: name,
      );
    } else if (value == "Flutter Code") {
      return SvgUtils.flutterWidget(
        icon,
        iconColor.toHex(),
        variant: variantIndex,
        name: name,
      );
    } else if (value == "Svelte") {
      return SvgUtils.svelteComponent(
        icon,
        iconColor.toHex(),
        variant: variantIndex,
        name: name,
      );
    } else if (value == "Angular") {
      return SvgUtils.angularComponent(
        icon,
        iconColor.toHex(),
        variant: variantIndex,
        name: name,
      );
    } else if (value == "Vue") {
      return SvgUtils.vueComponent(
        icon,
        iconColor.toHex(),
        variant: variantIndex,
        name: name,
      );
    } else {
      return "";
    }
  }

  void handleCopy(String value) {
    final text = getText(value);
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final currIcon = iconSets[variantIndex][widget.iconIndex];
    return PopupSurface(
      width: 600,
      alignment: Alignment(0, -0.3),
      child: SizedBox(
        height: 272,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main Icon Display
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(60, 89, 89, 89),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SuryaIcon(
                        size: 220,
                        strokeWidth: strokeWidth,
                        icon: currIcon,
                        color: iconColor,
                        color2: secondColor,
                        opacity: opacity,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(width: 40),
                IntrinsicWidth(
                  child: SizedBox(
                    height: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Icon Title
                        Text(
                          toCamelCase(
                            SearchManager.dataset![widget.iconIndex]['n']
                                as String,
                            capitalizeFirst: true,
                          ),
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Color1
                            SizedBox(
                              width: 110,
                              child: _buildIconBtn(
                                icon: Container(
                                  height: 14,
                                  width: 14,
                                  decoration: BoxDecoration(
                                    color: iconColor,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                ),
                                onPressed: () => handleColorPicker(1),
                                label: iconColor.toHex(),
                              ),
                            ),
                            const SizedBox(width: 12),

                            /// Stroke Width
                            Container(
                              height: 32,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white24),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              width: 140,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.line_weight,
                                    size: 16,
                                    color: widget.color,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Slider(
                                      padding: EdgeInsets.all(0),
                                      value: strokeWidth,
                                      activeColor: widget.color,
                                      onChanged:
                                          variantIndex < 1 || variantIndex > 5
                                          ? null
                                          : (value) {
                                              setState(() {
                                                strokeWidth = value;
                                              });
                                            },
                                      label: strokeWidth.toStringAsFixed(1),
                                      min: 0.5,
                                      max: 3,
                                      divisions: 5,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (variantIndex < 3) ...[
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Color2
                              SizedBox(
                                width: 110,
                                child: _buildIconBtn(
                                  icon: Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                      color: secondColor,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.white24),
                                    ),
                                  ),
                                  onPressed: () => handleColorPicker(2),
                                  label: secondColor.toHex(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Color2 Opacity
                              Container(
                                height: 32,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white24),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                width: 140,
                                child: Row(
                                  children: [
                                    SuryaIcon(
                                      icon: SITwotone.transparency,
                                      color: widget.color,
                                      size: 22,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Slider(
                                        padding: EdgeInsets.all(0),
                                        value: opacity,
                                        min: 0,
                                        max: 1,
                                        activeColor: widget.color,
                                        divisions: 10,
                                        label: opacity.toStringAsFixed(1),
                                        onChanged: (value) {
                                          setState(() {
                                            opacity = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Copy Button
                            buildSplitButton(
                              key: _keyPickerKey2,
                              icon: SuryaIcon(
                                icon: SIBulk.copy01,
                                color: widget.color,
                                size: 16,
                              ),
                              label: copyType,
                              onPressed: () => handleCopy(copyType),
                              onMenuItemSelected: (value) {
                                handleCopy(value);
                                setState(() {
                                  copyType = value;
                                });
                                Options.copyType = value;
                              },
                              menuItems: [
                                "Svg",
                                "React",
                                "Flutter",
                                "Svelte",
                                "Angular",
                                // "Flutter Icon",
                                // "React Icon",
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 8.0,
              children: iconSets.mapIndexed((index, iconSet) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      variantIndex = index;
                      // iconColor = widget.color;
                    });
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: index == widget.variantIndex
                            ? const Color.fromARGB(255, 83, 83, 83)
                            : Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SuryaIcon(
                      size: 28,
                      icon: iconSet[widget.iconIndex],
                      color: iconColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBtn({
    required Widget icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      icon: icon,
      label: Text(
        label,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget buildSplitButton({
    required String label,
    required VoidCallback onPressed,
    required List<String> menuItems,
    void Function(String)? onMenuItemSelected,
    required Widget icon,
    required GlobalKey<CustomPopupState> key,
  }) {
    final darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final clr = darkTheme
        ? const Color.fromARGB(32, 24, 5, 13)
        : const Color.fromARGB(32, 228, 209, 217);
    return Container(
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main action button
          TextButton.icon(
            onPressed: onPressed,
            icon: icon,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.only(left: 12, right: 4),
            ),
            label: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          CustomPopup(
            key: key,
            backgroundColor: clr,
            contentPadding: EdgeInsets.zero,
            contentDecoration: BoxDecoration(
              color: clr,
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(6),
              // backgroundBlendMode: BlendMode.clear,
            ),
            arrowColor: const Color.fromARGB(255, 82, 36, 55),
            content: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  // color: clr,
                  child: SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: menuItems.map((item) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              Navigator.of(context).pop();
                              // key.currentState?.hide();
                              if (onMenuItemSelected != null) {
                                onMenuItemSelected(item);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Text(item),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            child: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
