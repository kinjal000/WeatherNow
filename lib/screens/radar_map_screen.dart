import 'dart:async';
import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/time_theme.dart';
import 'account_screen.dart';

class RadarMapScreen extends StatefulWidget {
  final WeatherData weatherData;
  final TimeOfDayCategory timeCategory;
  final String userInitials;
  final String userEmail;
  final VoidCallback onLogout;

  const RadarMapScreen({
    super.key,
    required this.weatherData,
    required this.timeCategory,
    required this.userInitials,
    required this.userEmail,
    required this.onLogout,
  });

  @override
  State<RadarMapScreen> createState() => _RadarMapScreenState();
}

class _RadarMapScreenState extends State<RadarMapScreen> {
  int _selectedMode = 0; // 0: Rain, 1: Clouds, 2: Wind
  double _timelineValue = 0.0;
  bool _isPlaying = false;
  Timer? _playbackTimer;
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _transformationController.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _playbackTimer?.cancel();
      _playbackTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        setState(() {
          _timelineValue += 4;
          if (_timelineValue > 60) {
            _timelineValue = -60;
          }
        });
      });
    } else {
      _playbackTimer?.cancel();
    }
  }

  void _openAccountScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountScreen(
          userEmail: widget.userEmail,
          userInitials: widget.userInitials,
          timeCategory: widget.timeCategory,
          onLogout: widget.onLogout,
        ),
      ),
    );
  }

  String get _timelineTitle {
    switch (_selectedMode) {
      case 0:
        return 'Precipitation Timeline';
      case 1:
        return 'Cloud Movement Timeline';
      case 2:
        return 'Wind Flow Timeline';
      default:
        return 'Timeline';
    }
  }

  String get _timelineSubtitle {
    switch (_selectedMode) {
      case 0:
        return 'Past -60m → Now → Forecast +60m';
      case 1:
        return 'Satellite cloud coverage movement';
      case 2:
        return 'Animated wind vectors & speed';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'W',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LIVE RADAR STATIONS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                  Text(
                    'Weather Radar (${widget.weatherData.locationName.split(',').first})',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: _openAccountScreen,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF2D82FE),
                  child: Text(
                    widget.userInitials,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Mode Selector Tabs (Rain / Clouds / Wind)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xCC152033),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x33384AD0)),
            ),
            child: Row(
              children: [
                _buildModeTab(0, 'Rain', Icons.water_drop_rounded),
                _buildModeTab(1, 'Clouds', Icons.cloud_rounded),
                _buildModeTab(2, 'Wind', Icons.air_rounded),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Main Fixed Map Container
          Container(
            height: 360,
            decoration: BoxDecoration(
              color: const Color(0xFF0B132B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x33384AD0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Interactive Map Viewer for user pan/zoom (Map base + weather overlay rendering inside)
                  InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.8,
                    maxScale: 3.0,
                    boundaryMargin: const EdgeInsets.all(100),
                    child: Stack(
                      children: [
                        // Weather Radar Custom Painter (Renders Fixed Map Base + Dynamic Weather Overlay)
                        Positioned.fill(
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _RadarMapPainter(
                              mode: _selectedMode,
                              timelineValue: _timelineValue,
                            ),
                          ),
                        ),

                        // Fixed City Labels
                        const Positioned(
                          top: 60,
                          left: 110,
                          child: _CityLabel(name: 'Andheri', dist: '12 km'),
                        ),
                        const Positioned(
                          top: 110,
                          right: 70,
                          child: _CityLabel(name: 'Thane', dist: '24 km'),
                        ),
                        const Positioned(
                          bottom: 130,
                          right: 50,
                          child: _CityLabel(name: 'Navi Mumbai', dist: '18 km'),
                        ),
                        const Positioned(
                          bottom: 60,
                          left: 100,
                          child: _CityLabel(name: 'Colaba', dist: '15 km'),
                        ),

                        // Fixed Center Marker (Mumbai/Current Location)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF59E0B),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0x66F59E0B)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.weatherData.locationName.split(',').first,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Fixed Map Floating Controls (Top Right)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Column(
                      children: [
                        _buildFloatingMapButton(
                          icon: Icons.layers_outlined,
                          onTap: () {
                            setState(() => _selectedMode = (_selectedMode + 1) % 3);
                          },
                        ),
                        const SizedBox(height: 6),
                        _buildFloatingMapButton(
                          icon: Icons.add_rounded,
                          onTap: () {
                            final currentZoom = _transformationController.value.getMaxScaleOnAxis();
                            if (currentZoom < 3.0) {
                              _transformationController.value = Matrix4.diagonal3Values(currentZoom + 0.4, currentZoom + 0.4, 1.0);
                              setState(() {});
                            }
                          },
                        ),
                        const SizedBox(height: 2),
                        _buildFloatingMapButton(
                          icon: Icons.remove_rounded,
                          onTap: () {
                            final currentZoom = _transformationController.value.getMaxScaleOnAxis();
                            if (currentZoom > 0.8) {
                              _transformationController.value = Matrix4.diagonal3Values(currentZoom - 0.4, currentZoom - 0.4, 1.0);
                              setState(() {});
                            }
                          },
                        ),
                        const SizedBox(height: 6),
                        _buildFloatingMapButton(
                          icon: Icons.my_location_rounded,
                          onTap: () {
                            _transformationController.value = Matrix4.identity();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),

                  // Dynamic Dynamic Overlay Legend (Bottom Left inside map)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: _buildDynamicLegend(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Bottom Dynamic Timeline & Playback Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xCC152033),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x33384AD0)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _timelineTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _timelineSubtitle,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _togglePlayback,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Interactive Slider
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: _getModeAccentColor(),
                    inactiveTrackColor: const Color(0xFF1E293B),
                    thumbColor: _getModeAccentColor(),
                    trackHeight: 5,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                  ),
                  child: Slider(
                    min: -60,
                    max: 60,
                    value: _timelineValue,
                    onChanged: (val) {
                      setState(() {
                        _timelineValue = val;
                      });
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('-60 min (Past)', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getModeAccentColor().withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _getModeAccentColor().withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        _timelineValue == 0
                            ? 'Now'
                            : (_timelineValue > 0 ? '+${_timelineValue.round()}m (Forecast)' : '${_timelineValue.round()}m (Past)'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getModeAccentColor(),
                        ),
                      ),
                    ),
                    const Text('+60 min (Forecast)', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getModeAccentColor() {
    switch (_selectedMode) {
      case 0:
        return const Color(0xFF38BDF8); // Cyan/Blue for Rain
      case 1:
        return const Color(0xFFE2E8F0); // White/Slate for Clouds
      case 2:
        return const Color(0xFFF59E0B); // Amber/Yellow for Wind
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Widget _buildDynamicLegend() {
    String labelStart;
    String labelEnd;
    List<Color> gradientColors;

    if (_selectedMode == 0) {
      // Rain: Light -> Heavy
      labelStart = 'Light';
      labelEnd = 'Heavy';
      gradientColors = const [
        Color(0xFF38BDF8), // Cyan (Light)
        Color(0xFF22C55E), // Green
        Color(0xFFEAB308), // Yellow
        Color(0xFFEF4444), // Red (Heavy)
        Color(0xFFA855F7), // Purple (Severe)
      ];
    } else if (_selectedMode == 1) {
      // Clouds: Clear -> Overcast
      labelStart = 'Clear';
      labelEnd = 'Overcast';
      gradientColors = [
        Colors.white.withValues(alpha: 0.1),
        Colors.white.withValues(alpha: 0.4),
        Colors.white.withValues(alpha: 0.7),
        Colors.white.withValues(alpha: 0.95),
      ];
    } else {
      // Wind: Calm -> Strong
      labelStart = 'Calm';
      labelEnd = 'Strong';
      gradientColors = const [
        Color(0xFF2DD4BF), // Teal (Calm)
        Color(0xFF3B82F6), // Blue
        Color(0xFFF59E0B), // Yellow
        Color(0xFFF97316), // Orange (Strong)
      ];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xEE0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33384AD0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$labelStart  ',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
          ),
          Container(
            width: 70,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(colors: gradientColors),
            ),
          ),
          Text(
            '  $labelEnd',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab(int index, String title, IconData icon) {
    final bool isSelected = _selectedMode == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMode = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2D82FE) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingMapButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0x33384AD0)),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class _CityLabel extends StatelessWidget {
  final String name;
  final String dist;

  const _CityLabel({required this.name, required this.dist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCBD5E1),
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ),
        Text(
          dist,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _RadarMapPainter extends CustomPainter {
  final int mode;
  final double timelineValue;

  _RadarMapPainter({required this.mode, required this.timelineValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // --- 1. FIXED MAP BASE (Rings & Radar Grid - Station Position Unchanged) ---
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double step = 50;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Fixed Concentric Radar Range Rings (50km, 100km, 150km)
    canvas.drawCircle(center, 60, gridPaint);
    canvas.drawCircle(center, 120, gridPaint);
    canvas.drawCircle(center, 180, gridPaint);

    // Range ring text labels
    final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = const TextSpan(
      text: '50km',
      style: TextStyle(fontSize: 8, color: Color(0xFF475569)),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx + 62, center.dy - 12));

    textPainter.text = const TextSpan(
      text: '100km',
      style: TextStyle(fontSize: 8, color: Color(0xFF475569)),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx + 122, center.dy - 12));

    // --- 2. DYNAMIC WEATHER OVERLAY (ANIMATES WITH TIMELINE) ---
    // Calculate displacement vector for timeline (-60m to +60m)
    final double normalizedTime = (timelineValue + 60) / 120.0; // 0.0 to 1.0

    if (mode == 0) {
      // --- MODE 0: RAIN (Realistic Precipitation Cells) ---
      _drawRainPrecipitationOverlay(canvas, size, center, normalizedTime);
    } else if (mode == 1) {
      // --- MODE 1: CLOUDS (Cloud Movement & Coverage) ---
      _drawCloudCoverageOverlay(canvas, size, center, normalizedTime);
    } else {
      // --- MODE 2: WIND (Moving Wind Streamlines & Vectors) ---
      _drawWindFlowOverlay(canvas, size, center, normalizedTime);
    }
  }

  void _drawRainPrecipitationOverlay(Canvas canvas, Size size, Offset center, double time) {
    // Drifting motion vector across the fixed map (SW to NE direction)
    final double dx = (time - 0.5) * 160;
    final double dy = -(time - 0.5) * 120;

    // Precipitation Cell 1 (Main heavy storm cell near center-east)
    _drawRadarCell(
      canvas: canvas,
      center: Offset(center.dx + 30 + dx, center.dy - 20 + dy),
      radiusLight: 90,
      radiusMedium: 55,
      radiusHeavy: 25,
      opacity: 0.85,
    );

    // Precipitation Cell 2 (Moderate rain cell north-west)
    _drawRadarCell(
      canvas: canvas,
      center: Offset(center.dx - 80 + dx * 0.9, center.dy - 70 + dy * 0.9),
      radiusLight: 70,
      radiusMedium: 40,
      radiusHeavy: 15,
      opacity: 0.75,
    );

    // Precipitation Cell 3 (Passing rain band south)
    _drawRadarCell(
      canvas: canvas,
      center: Offset(center.dx + 10 + dx * 1.1, center.dy + 80 + dy * 1.1),
      radiusLight: 100,
      radiusMedium: 50,
      radiusHeavy: 0,
      opacity: 0.65,
    );
  }

  void _drawRadarCell({
    required Canvas canvas,
    required Offset center,
    required double radiusLight,
    required double radiusMedium,
    required double radiusHeavy,
    required double opacity,
  }) {
    // Light rain outer ring (Cyan -> Green)
    if (radiusLight > 0) {
      final lightPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF22C55E).withValues(alpha: opacity * 0.6),
            const Color(0xFF38BDF8).withValues(alpha: opacity * 0.35),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radiusLight));
      canvas.drawCircle(center, radiusLight, lightPaint);
    }

    // Medium rain core (Yellow/Orange)
    if (radiusMedium > 0) {
      final medPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFEAB308).withValues(alpha: opacity * 0.8),
            const Color(0xFFF97316).withValues(alpha: opacity * 0.5),
            Colors.transparent,
          ],
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radiusMedium));
      canvas.drawCircle(center, radiusMedium, medPaint);
    }

    // Heavy rain core (Red/Purple)
    if (radiusHeavy > 0) {
      final heavyPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFA855F7).withValues(alpha: opacity * 0.95),
            const Color(0xFFEF4444).withValues(alpha: opacity * 0.9),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radiusHeavy));
      canvas.drawCircle(center, radiusHeavy, heavyPaint);
    }
  }

  void _drawCloudCoverageOverlay(Canvas canvas, Size size, Offset center, double time) {
    // Cloud drift offset (West to East)
    final double driftX = (time - 0.5) * 180;
    final double driftY = (time - 0.5) * 40;

    final cloudPositions = [
      Offset(center.dx - 100 + driftX, center.dy - 60 + driftY),
      Offset(center.dx + 40 + driftX, center.dy - 90 + driftY),
      Offset(center.dx - 40 + driftX, center.dy + 40 + driftY),
      Offset(center.dx + 90 + driftX, center.dy + 30 + driftY),
    ];

    final cloudRadii = [110.0, 130.0, 100.0, 120.0];

    for (int i = 0; i < cloudPositions.length; i++) {
      final pos = cloudPositions[i];
      final r = cloudRadii[i];

      final cloudPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.45),
            const Color(0xFF94A3B8).withValues(alpha: 0.25),
            Colors.transparent,
          ],
          stops: const [0.0, 0.65, 1.0],
        ).createShader(Rect.fromCircle(center: pos, radius: r));

      canvas.drawCircle(pos, r, cloudPaint);
    }
  }

  void _drawWindFlowOverlay(Canvas canvas, Size size, Offset center, double time) {
    // Wind vector grid with moving wind arrows & particles
    const double gridSpacing = 40.0;
    final double phase = time * 80.0;

    final arrowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    for (double x = 20; x < size.width; x += gridSpacing) {
      for (double y = 20; y < size.height; y += gridSpacing) {
        // Calculate distance from center to give variation in wind strength
        final distFromCenter = (Offset(x, y) - center).distance;
        final isStrong = distFromCenter < 120;

        // Color based on wind intensity (Calm teal -> Strong yellow/orange)
        final Color windColor = isStrong
            ? const Color(0xFFF59E0B).withValues(alpha: 0.85)
            : const Color(0xFF2DD4BF).withValues(alpha: 0.6);

        arrowPaint.color = windColor;

        // Flow movement offset
        final double offsetX = (x + phase) % gridSpacing - (gridSpacing / 2);
        final double startX = x + offsetX;
        final double startY = y + (offsetX * 0.4);

        // Draw wind direction vector arrow (45-degree angle NE flow)
        const double length = 18.0;
        const double dx = length * 0.866; // cos(30 deg)
        const double dy = -length * 0.5;  // sin(30 deg)

        canvas.drawLine(Offset(startX, startY), Offset(startX + dx, startY + dy), arrowPaint);

        // Arrow tip head
        canvas.drawLine(Offset(startX + dx, startY + dy), Offset(startX + dx - 4, startY + dy + 4), arrowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RadarMapPainter oldDelegate) {
    return oldDelegate.mode != mode || oldDelegate.timelineValue != timelineValue;
  }
}

