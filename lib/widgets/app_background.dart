import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: child,
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffF1F5F9), // Slate 100
            Color(0xffE2E8F0), // Slate 200
            Color(0xffF1F5F9), // Slate 100
          ],
        ),
      ),
      child: Stack(
        children: [
          // Optional: Add decorative circles for a modern look
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 200,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.03),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.03),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
