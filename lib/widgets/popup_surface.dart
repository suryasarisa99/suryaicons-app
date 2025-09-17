import 'dart:ui';

import 'package:flutter/material.dart';

class PopupSurface extends StatelessWidget {
  final double radius;
  final Widget child;
  final double? width;
  final Alignment alignment;

  const PopupSurface({
    this.width,
    required this.child,
    this.radius = 16,
    super.key,
    this.alignment = const Alignment(0, 0),
  });

  @override
  Widget build(BuildContext context) {
    final darkTheme = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: alignment,
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: darkTheme
                      ? Colors.white24
                      : const Color.fromARGB(255, 220, 220, 220),
                ),
              ),
              child: // your child widget here
              Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
