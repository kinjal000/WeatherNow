import 'package:flutter/material.dart';

class WeatherIconWidget extends StatelessWidget {
  final String condition;
  final double size;

  const WeatherIconWidget({
    super.key,
    required this.condition,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final lower = condition.toLowerCase();

    if (lower.contains('rain')) {
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.cloud, color: Colors.blueGrey.shade300, size: size * 0.8),
            Positioned(
              bottom: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.water_drop, color: Colors.blue.shade400, size: size * 0.35),
                  Icon(Icons.water_drop, color: Colors.blue.shade600, size: size * 0.35),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (lower.contains('thunder')) {
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.cloud, color: Colors.grey.shade400, size: size * 0.8),
            Positioned(
              bottom: 0,
              child: Icon(Icons.flash_on, color: Colors.amber.shade600, size: size * 0.5),
            ),
          ],
        ),
      );
    } else if (lower.contains('sunny') || lower.contains('clear')) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x33FFB300),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      );
    } else {
      // Partly cloudy or cloudy
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: size * 0.55,
                height: size * 0.55,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFB300),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              left: 2,
              child: Container(
                padding: EdgeInsets.all(size * 0.08),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size * 0.4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.cloud,
                  color: Colors.lightBlue.shade100,
                  size: size * 0.65,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
