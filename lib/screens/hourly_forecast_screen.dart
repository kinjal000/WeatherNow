import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/time_theme.dart';
import '../widgets/weather_chart.dart';
import '../widgets/weather_icon.dart';
import 'account_screen.dart';

class HourlyForecastScreen extends StatefulWidget {
  final WeatherData weatherData;
  final TimeOfDayCategory timeCategory;
  final String userInitials;
  final String userEmail;
  final VoidCallback onLogout;

  const HourlyForecastScreen({
    super.key,
    required this.weatherData,
    required this.timeCategory,
    required this.userInitials,
    required this.userEmail,
    required this.onLogout,
  });

  @override
  State<HourlyForecastScreen> createState() => _HourlyForecastScreenState();
}

class _HourlyForecastScreenState extends State<HourlyForecastScreen> {
  int _selectedTabIndex = 0;

  /// Generate tomorrow's forecast data (shifted +1-2°C with different conditions)
  List<HourlyForecast> get _tomorrowHourly {
    return [
      HourlyForecast(time: '8 AM', label: 'Morning', temp: 24, condition: 'Sunny', rainChance: 2, windSpeed: 8),
      HourlyForecast(time: '10 AM', label: 'Forecast', temp: 26, condition: 'Sunny', rainChance: 3, windSpeed: 9),
      HourlyForecast(time: '12 PM', label: 'Afternoon', temp: 30, condition: 'Partly cloudy', rainChance: 10, windSpeed: 12),
      HourlyForecast(time: '2 PM', label: 'Forecast', temp: 31, condition: 'Partly cloudy', rainChance: 15, windSpeed: 14),
      HourlyForecast(time: '4 PM', label: 'Forecast', temp: 29, condition: 'Cloudy', rainChance: 25, windSpeed: 16),
      HourlyForecast(time: '6 PM', label: 'Evening', temp: 27, condition: 'Light rain', rainChance: 40, windSpeed: 18),
      HourlyForecast(time: '8 PM', label: 'Forecast', temp: 25, condition: 'Light rain', rainChance: 35, windSpeed: 15),
      HourlyForecast(time: '10 PM', label: 'Night', temp: 23, condition: 'Cloudy', rainChance: 20, windSpeed: 10),
    ];
  }

  /// Get the correct hourly data based on selected tab
  List<HourlyForecast> get _activeHourlyData {
    if (_selectedTabIndex == 1) {
      return _tomorrowHourly;
    }
    return widget.weatherData.hourly;
  }

  /// Get today's and tomorrow's date strings
  String get _todayDateStr {
    final now = DateTime.now();
    return '${now.day} ${_monthName(now.month)}';
  }

  String get _tomorrowDateStr {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return '${tomorrow.day} ${_monthName(tomorrow.month)}';
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
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
    final hourlyData = _activeHourlyData;
    final chartTemps = hourlyData.take(6).map((e) => e.temp).toList();
    final chartTimes = hourlyData.take(6).map((e) => e.time).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
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
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Tappable avatar with user initials
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

          // Day Tabs (Today / Tomorrow)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xCC152033),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x33384AD0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 0 ? const Color(0xFF2D82FE) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _selectedTabIndex == 0 ? Colors.white : const Color(0xFF94A3B8),
                            ),
                          ),
                          Text(
                            _todayDateStr,
                            style: TextStyle(
                              fontSize: 11,
                              color: _selectedTabIndex == 0 ? const Color(0xCCFFFFFF) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 1 ? const Color(0xFF2D82FE) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Tomorrow',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _selectedTabIndex == 1 ? Colors.white : const Color(0xFF94A3B8),
                            ),
                          ),
                          Text(
                            _tomorrowDateStr,
                            style: TextStyle(
                              fontSize: 11,
                              color: _selectedTabIndex == 1 ? const Color(0xCCFFFFFF) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Temperature Trend Chart
          TemperatureChartWidget(temps: chartTemps, times: chartTimes),

          const SizedBox(height: 24),

          // Outlook Header — changes based on tab
          Text(
            _selectedTabIndex == 0 ? "Today's Outlook" : "Tomorrow's Outlook",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // Hourly List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: hourlyData.length,
            itemBuilder: (context, index) {
              final item = hourlyData[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xCC152033),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x33384AD0)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.time,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),

                    WeatherIconWidget(condition: item.condition, size: 34),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.condition,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.air_rounded, size: 12, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(
                                '${item.windSpeed.round()} km/h',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        const Icon(Icons.water_drop_outlined, size: 14, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 2),
                        Text(
                          '${item.rainChance}%',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                        ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    Text(
                      '${item.temp.round()}°',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
