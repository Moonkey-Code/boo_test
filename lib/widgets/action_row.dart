// lib/widgets/action_row.dart

import 'package:flutter/material.dart';
import 'package:boo_test/widgets/bottom_nav.dart';

/// A reusable action panel combining swipe buttons and bottom navigation.
/// Designed for card-matching flows (e.g., dating apps).
/// Each action button is represented as a stylized circular widget.
class ActionRow extends StatelessWidget {
  /// Callback executed when the user presses the "pass" (X) button.
  final VoidCallback onPass;

  /// Callback executed when the user presses the "like" (heart) button.
  final VoidCallback onLike;

  /// Currently active index in the bottom navigation bar.
  final int selectedNavIndex;

  /// Handler for tapping an item in the bottom navigation.
  final ValueChanged<int>? onNavTap;

  const ActionRow({
    super.key,
    required this.onPass,
    required this.onLike,
    this.selectedNavIndex = 0,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- Main Action Buttons Row ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Boost / Rocket icon (small decorative action)
              _outerInnerCircle(
                outerSize: 65,
                innerSize: 55,
                innerColor: Colors.black.withValues(alpha: 0.6),
                icon: Icons.rocket_launch,
                iconColor: Colors.white,
                onTap: () {},
              ),

              const SizedBox(width: 14),

              // Pass button (X), red accent
              _outerInnerCircle(
                outerSize: 65,
                innerSize: 55,
                innerColor: Colors.black.withValues(alpha: 0.6),
                icon: Icons.close,
                iconColor: Colors.red,
                onTap: onPass,
              ),

              const SizedBox(width: 14),

              // Like button (heart), primary highlight
              _outerInnerCircle(
                outerSize: 65,
                innerSize: 55,
                innerColor: Colors.black.withValues(alpha: 0.6),
                icon: Icons.favorite,
                iconColor: Colors.pink,
                onTap: () {},
              ),

              const SizedBox(width: 14),

              // Superlike button (variant color)
              _outerInnerCircle(
                outerSize: 65,
                innerSize: 55,
                innerColor: Colors.black.withValues(alpha: 0.6),
                icon: Icons.favorite,
                iconColor: Colors.pinkAccent,
                onTap: onLike,
              ),

              const SizedBox(width: 14),

              // Send / message action
              _outerInnerCircle(
                outerSize: 65,
                innerSize: 55,
                innerColor: Colors.black.withValues(alpha: 0.6),
                icon: Icons.send,
                iconColor: Colors.white,
                onTap: () {},
              ),
            ],
          ),
        ),

        // --- Bottom Navigation Section ---
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: BooBottomNav(
            currentIndex: selectedNavIndex,
            onTap: (i) => onNavTap?.call(i!),
          ),
        ),
      ],
    );
  }

  /// Creates a glossy dual-layer circular button consisting of:
  /// - An outer circle with subtle glow.
  /// - An inner circle containing the action icon.
  Widget _outerInnerCircle({
    required double outerSize,
    required double innerSize,
    required Color innerColor,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: outerSize,
        height: outerSize,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          boxShadow: [
            // White glow effect surrounding the button
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.45),
              blurRadius: 14,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              color: innerColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: innerSize * 0.46,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}