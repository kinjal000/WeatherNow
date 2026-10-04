import 'package:flutter/material.dart';
import '../utils/time_theme.dart';

class AccountScreen extends StatelessWidget {
  final String userEmail;
  final String userInitials;
  final TimeOfDayCategory timeCategory;
  final VoidCallback onLogout;

  const AccountScreen({
    super.key,
    required this.userEmail,
    required this.userInitials,
    required this.timeCategory,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B162C),
      body: Container(
        decoration: BoxDecoration(
          gradient: TimeTheme.getBackgroundGradient(timeCategory),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xCC152033),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0x33384AD0)),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'My Account',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Column(
                    children: [
                      // Avatar Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xCC152033),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0x33F59E0B)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22F59E0B),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Large Avatar with user initials
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF2D82FE), Color(0xFF1E40AF)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2D82FE).withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  userInitials,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'WeatherNow User',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Settings Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xCC152033),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0x33384AD0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PREFERENCES',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Color(0xFFF59E0B),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildSettingRow(
                              Icons.thermostat_rounded,
                              'Temperature Unit',
                              '°C (Celsius)',
                            ),
                            const Divider(color: Color(0x33384AD0), height: 24),
                            _buildSettingRow(
                              Icons.air_rounded,
                              'Wind Speed Unit',
                              'km/h',
                            ),
                            const Divider(color: Color(0x33384AD0), height: 24),
                            _buildSettingRow(
                              Icons.location_on_outlined,
                              'Default City',
                              'Mumbai',
                            ),
                            const Divider(color: Color(0x33384AD0), height: 24),
                            _buildSettingRow(
                              Icons.notifications_outlined,
                              'Weather Alerts',
                              'Enabled',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // About Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xCC152033),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0x33384AD0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ABOUT',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Color(0xFFF59E0B),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildSettingRow(
                              Icons.info_outline_rounded,
                              'App Version',
                              '1.0.0',
                            ),
                            const Divider(color: Color(0x33384AD0), height: 24),
                            _buildSettingRow(
                              Icons.cloud_outlined,
                              'Data Source',
                              'Open-Meteo API',
                            ),
                            const Divider(color: Color(0x33384AD0), height: 24),
                            _buildSettingRow(
                              Icons.school_outlined,
                              'Project',
                              'B.Tech Flutter',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            onLogout();
                          },
                          icon: const Icon(Icons.logout_rounded, color: Colors.white),
                          label: const Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0x33F59E0B),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFF59E0B), size: 16),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
