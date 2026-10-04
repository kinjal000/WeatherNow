import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/time_theme.dart';
import 'account_screen.dart';

class WeatherAlertsScreen extends StatefulWidget {
  final WeatherData weatherData;
  final TimeOfDayCategory timeCategory;
  final String userInitials;
  final String userEmail;
  final VoidCallback onLogout;

  const WeatherAlertsScreen({
    super.key,
    required this.weatherData,
    required this.timeCategory,
    required this.userInitials,
    required this.userEmail,
    required this.onLogout,
  });

  @override
  State<WeatherAlertsScreen> createState() => _WeatherAlertsScreenState();
}

class _WeatherAlertsScreenState extends State<WeatherAlertsScreen> {
  bool _notificationsOn = true;

  void _showSafetyDialog(BuildContext context, WeatherAlert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF152033),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.shield_rounded, color: Color(0xFFF59E0B)),
            SizedBox(width: 8),
            Text('Safety Guidance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('• Stay indoors during peak rainfall after 6:00 PM.', style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFFCBD5E1))),
            SizedBox(height: 8),
            Text('• Avoid low-lying flooded areas and waterlogged streets.', style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFFCBD5E1))),
            SizedBox(height: 8),
            Text('• Keep emergency contacts and charged power banks handy.', style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFFCBD5E1))),
            SizedBox(height: 8),
            Text('• Follow municipal transport updates for train/bus schedules.', style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFFCBD5E1))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Understood', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                  Text(
                    widget.weatherData.locationName.split(',').first.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                  const Text(
                    'Severe Weather Alerts',
                    style: TextStyle(
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

          const SizedBox(height: 20),

          // Active Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xCC152033),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x33384AD0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0x33F59E0B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFFF59E0B),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '1 Active Weather Alert',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Heavy rain expected after 6 PM',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Active Now Section
          const Text(
            'Active Now',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // Warning Alert Card
          for (final alert in widget.weatherData.alerts.where((a) => a.isActive))
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xCC152033),
                borderRadius: BorderRadius.circular(24),
                border: const Border(
                  left: BorderSide(color: Color(0xFFF59E0B), width: 6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B), size: 18),
                          SizedBox(width: 6),
                          Text(
                            'WARNING',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0x33F59E0B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          alert.levelLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    alert.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alert.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFCBD5E1),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0x33384AD0), height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.map_outlined, size: 16, color: Color(0xFF64748B)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Affected area', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                  Text(
                                    alert.affectedArea,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF64748B)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Valid until', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                  Text(
                                    alert.validUntil,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => _showSafetyDialog(context, alert),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'View safety guidance',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: Color(0xFFF59E0B)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Recent Updates Section
          const Text(
            'Recent Updates',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // Resolved Alert Card
          for (final alert in widget.weatherData.alerts.where((a) => !a.isActive))
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xCC152033),
                borderRadius: BorderRadius.circular(24),
                border: const Border(
                  left: BorderSide(color: Color(0xFF10B981), width: 6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 18),
                          SizedBox(width: 6),
                          Text(
                            'RESOLVED',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0x3310B981),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          alert.levelLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    alert.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    alert.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    alert.validUntil,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Notification Toggle Switch Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xCC152033),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x33384AD0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0x33F59E0B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFFF59E0B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Stay informed',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Notifications are on for severe weather alerts.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _notificationsOn,
                  activeTrackColor: const Color(0xFFF59E0B),
                  onChanged: (val) {
                    setState(() => _notificationsOn = val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
