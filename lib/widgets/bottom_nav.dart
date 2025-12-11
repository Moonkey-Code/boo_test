// lib/widgets/bottom_nav.dart

import 'dart:ui';
import 'package:flutter/material.dart';

/// A translucent, blurred bottom navigation bar used across the app.
/// Provides 5 primary navigation actions with consistent styling.
class BooBottomNav extends StatelessWidget {
  /// The active navigation index.
  final int currentIndex;

  /// Callback fired when a nav item is tapped.
  final ValueChanged<int?>? onTap;

  const BooBottomNav({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF2CE7DC);

    return ClipRRect(
      // Applies the blur effect to child widgets
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
          color: Colors.black.withValues(alpha: 0.36), // translucent background
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _navItem(index: 0, icon: Icons.favorite, label: 'Match', accent: accent, onTap: onTap),
              _navItem(index: 1, icon: Icons.search, label: 'Search', accent: accent, onTap: onTap),
              _navItem(index: 2, icon: Icons.add_circle_outline_rounded, label: 'Create', accent: accent, onTap: onTap),
              _navItem(index: 3, icon: Icons.public, label: 'Universes', accent: accent, onTap: onTap),
              _navItem(index: 4, icon: Icons.message, label: 'Messages', accent: accent, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // NAVIGATION ITEM WIDGET
  // Each item contains: circular icon container + label.
  // ==========================================================
  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
    required Color accent,
    ValueChanged<int?>? onTap,
  }) {
    final iconColor = Colors.white70;
    final bg = Colors.black.withValues(alpha: 0.15); // soft dark background

    return GestureDetector(
      onTap: () => onTap?.call(index),
      behavior: HitTestBehavior.opaque, // ensures full area is tappable
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
          ),

          const SizedBox(height: 6),

          // Text label below the icon
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}