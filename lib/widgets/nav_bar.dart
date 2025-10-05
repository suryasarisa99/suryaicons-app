import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:suryaicons/bulk_rounded.dart';
import 'package:suryaicons/duotone_rounded.dart';
import 'package:suryaicons/suryaicons.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    this.handleTextChange,
    required this.color,
    required this.showColorPicker,
  });
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Function(String)? handleTextChange;
  final Color color;
  final VoidCallback showColorPicker;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final darkTheme = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: preferredSize.height,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const SizedBox(width: 38),
              Text(
                'Surya Icons',
                style: TextStyle(
                  fontSize: 20,
                  color: HSLColor.fromColor(color).withLightness(0.7).toColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: showColorPicker,
                icon: SuryaIcon(icon: SIBulk.colors, color: color),
              ),
              const SizedBox(width: 12),
              buildSearchBar(darkTheme),
              SizedBox(width: 38),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar(bool darkTheme) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          suffixIconConstraints: BoxConstraints(minWidth: 24, minHeight: 24),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SuryaIcon(
              size: 24,
              strokeWidth: 1,
              icon: SIDuotone.search01,
              color: color,
            ),
          ),
          fillColor: darkTheme
              ? Colors.black.withValues(alpha: 0.55)
              : const Color.fromARGB(169, 254, 247, 255),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          hintText: 'Search Icons',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide(color: color, width: 1.5),
          ),
        ),
        onChanged: handleTextChange,
      ),
    );
  }
}
