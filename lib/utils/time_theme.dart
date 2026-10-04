import 'package:flutter/material.dart';

enum TimeOfDayCategory { morning, afternoon, evening, night }

class TimeTheme {
  static TimeOfDayCategory getCategoryByHour(int hour) {
    if (hour >= 6 && hour < 12) {
      return TimeOfDayCategory.morning;
    } else if (hour >= 12 && hour < 17) {
      return TimeOfDayCategory.afternoon;
    } else if (hour >= 17 && hour < 20) {
      return TimeOfDayCategory.evening;
    } else {
      return TimeOfDayCategory.night;
    }
  }

  static String getGreeting(TimeOfDayCategory category) {
    switch (category) {
      case TimeOfDayCategory.morning:
        return 'GOOD MORNING';
      case TimeOfDayCategory.afternoon:
        return 'GOOD AFTERNOON';
      case TimeOfDayCategory.evening:
        return 'GOOD EVENING';
      case TimeOfDayCategory.night:
        return 'GOOD NIGHT';
    }
  }

  // SkyView Dark Premium Mesh Gradient
  static LinearGradient getBackgroundGradient(TimeOfDayCategory category) {
    switch (category) {
      case TimeOfDayCategory.morning:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F1E36), // Deep midnight blue
            Color(0xFF172B4D), // Dark slate blue
            Color(0xFF25395C), // Soft sky depth
            Color(0xFF111C2E), // Base navy
          ],
        );
      case TimeOfDayCategory.afternoon:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B162C),
            Color(0xFF14274E),
            Color(0xFF1F3A60),
            Color(0xFF0D1B30),
          ],
        );
      case TimeOfDayCategory.evening:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF120E24), // Dusk deep purple navy
            Color(0xFF221638), // Sunset purple
            Color(0xFF381F42), // Warm copper purple glow
            Color(0xFF0E0B1A),
          ],
        );
      case TimeOfDayCategory.night:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF070D18), // Midnight dark slate
            Color(0xFF0D1829), // Deep starry blue
            Color(0xFF122238),
            Color(0xFF050912),
          ],
        );
    }
  }

  static Color getTextColor(TimeOfDayCategory category) {
    return Colors.white;
  }

  static Color getSubtextColor(TimeOfDayCategory category) {
    return const Color(0xFF94A3B8);
  }

  static Color getGoldAccent() {
    return const Color(0xFFF59E0B); // SkyView Gold Amber
  }

  static Color getCardBackgroundColor() {
    return const Color(0xCC152033); // Dark Glass Slate
  }

  static Color getCardBorderColor() {
    return const Color(0x33384AD0);
  }
}
