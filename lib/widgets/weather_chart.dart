import 'package:flutter/material.dart';

class TemperatureChartWidget extends StatelessWidget {
  final List<double> temps;
  final List<String> times;

  const TemperatureChartWidget({
    super.key,
    required this.temps,
    required this.times,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xCC152033),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x33384AD0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.show_chart_rounded, color: Color(0xFFF59E0B), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Temperature Trend',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x33F59E0B)),
                ),
                child: const Text(
                  'Today, °C',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            child: CustomPaint(
              size: Size.infinite,
              painter: _ChartPainter(temps: temps, times: times),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> temps;
  final List<String> times;

  _ChartPainter({required this.temps, required this.times});

  @override
  void paint(Canvas canvas, Size size) {
    if (temps.isEmpty) return;

    final double minTemp = temps.reduce((a, b) => a < b ? a : b) - 2;
    final double maxTemp = temps.reduce((a, b) => a > b ? a : b) + 2;
    final double range = maxTemp - minTemp;

    final double stepX = size.width / (temps.length - 1);
    final double chartHeight = size.height - 24;

    final List<Offset> points = [];
    for (int i = 0; i < temps.length; i++) {
      final double x = i * stepX;
      final double normalizedY = (temps[i] - minTemp) / range;
      final double y = chartHeight - (normalizedY * chartHeight);
      points.add(Offset(x, y));
    }

    final Path linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final controlX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    final Path fillPath = Path.from(linePath);
    fillPath.lineTo(size.width, chartHeight);
    fillPath.lineTo(0, chartHeight);
    fillPath.close();

    final Paint fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x66F59E0B), Color(0x05F59E0B)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight));

    canvas.drawPath(fillPath, fillPaint);

    final Paint glowPaint = Paint()
      ..color = const Color(0x66F59E0B)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(linePath, glowPaint);

    final Paint linePaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawPath(linePath, linePaint);

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < points.length; i++) {
      final pt = points[i];

      canvas.drawCircle(pt, 5, Paint()..color = const Color(0xFFF59E0B));
      canvas.drawCircle(pt, 3, Paint()..color = Colors.white);

      textPainter.text = TextSpan(
        text: times[i],
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(pt.dx - (textPainter.width / 2), size.height - 16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
