import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/time_theme.dart';
import '../widgets/weather_chart.dart';
import '../widgets/weather_icon.dart';
import 'account_screen.dart';


class DashboardScreen extends StatefulWidget {
  final WeatherData weatherData;
  final TimeOfDayCategory timeCategory;
  final VoidCallback onRefresh;
  final Function(int) onNavigateTab;
  final Function(String) onSelectCity;
  final String userInitials;
  final String userEmail;
  final VoidCallback onLogout;

  const DashboardScreen({
    super.key,
    required this.weatherData,
    required this.timeCategory,
    required this.onRefresh,
    required this.onNavigateTab,
    required this.onSelectCity,
    required this.userInitials,
    required this.userEmail,
    required this.onLogout,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _popularCities = [
    {'name': 'Mumbai', 'temp': '27°'},
    {'name': 'New York', 'temp': '18°'},
    {'name': 'London', 'temp': '16°'},
    {'name': 'Tokyo', 'temp': '22°'},
    {'name': 'Paris', 'temp': '20°'},
    {'name': 'Sydney', 'temp': '24°'},
    {'name': 'Dubai', 'temp': '28°'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      widget.onSelectCity(query);
      FocusScope.of(context).unfocus(); // Close keyboard
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

  @override
  Widget build(BuildContext context) {
    final current = widget.weatherData.current;

    final chartTemps = widget.weatherData.hourly.take(6).map((e) => e.temp).toList();
    final chartTimes = widget.weatherData.hourly.take(6).map((e) => e.time).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Search Bar + Avatar
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xCC152033),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x33384AD0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Color(0xFFF59E0B), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          onSubmitted: (_) => _performSearch(),
                          decoration: const InputDecoration(
                            hintText: 'Search city or location...',
                            hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _performSearch,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: widget.onRefresh,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xCC152033),
                  child: const Icon(Icons.refresh, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 8),
              // User avatar — opens account screen
              GestureDetector(
                onTap: _openAccountScreen,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF2D82FE),
                  child: Text(
                    widget.userInitials,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 1. Current Weather prominently displayed
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFFF59E0B), size: 20),
                    const SizedBox(width: 6),
                    Text(
                      widget.weatherData.locationName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WeatherIconWidget(condition: current.condition, size: 64),
                    const SizedBox(width: 16),
                    Text(
                      '${current.temp.round()}°',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  current.condition,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'H: ${current.tempHigh.round()}°   L: ${current.tempLow.round()}°',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Core details
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xCC152033),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x33384AD0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSmallDetailItem(Icons.water_drop_outlined, '${current.humidity}%', 'Humidity'),
                _buildSmallDetailItem(Icons.air_rounded, '${current.windSpeed.round()} km/h', 'Wind'),
                _buildSmallDetailItem(Icons.thermostat, '${current.feelsLike.round()}°', 'Feels Like'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 2. Trend Chart
          const Text(
            'Temperature Trend',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          TemperatureChartWidget(temps: chartTemps, times: chartTimes),

          const SizedBox(height: 24),

          // 3. Forecast Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Forecast',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  widget.onNavigateTab(1); // Hourly/Forecast tab
                },
                child: const Text(
                  'More >',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2D82FE)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.weatherData.daily.length,
              itemBuilder: (context, index) {
                final day = widget.weatherData.daily[index];
                final bool isToday = index == 0;

                return Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xCC152033),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isToday ? const Color(0xFFF59E0B) : const Color(0x33384AD0),
                      width: isToday ? 1.5 : 1.0,
                    ),
                    boxShadow: isToday
                        ? const [BoxShadow(color: Color(0x33F59E0B), blurRadius: 10)]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        isToday ? 'Today' : day.dayName.substring(0, 3),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isToday ? const Color(0xFFF59E0B) : Colors.white,
                        ),
                      ),
                      WeatherIconWidget(condition: day.condition, size: 32),
                      Text(
                        '${day.tempHigh.round()}° / ${day.tempLow.round()}°',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // 4. Alerts Banner
          if (widget.weatherData.alerts.isNotEmpty)
            GestureDetector(
              onTap: () => widget.onNavigateTab(2),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C2D12), Color(0xFF9A3412)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF97316)),
                  boxShadow: const [
                    BoxShadow(color: Color(0x44F97316), blurRadius: 12),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFC2410C),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.weatherData.alerts.first.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                          ),
                          Text(
                            widget.weatherData.alerts.first.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Color(0xFFFFEDD5)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),

          // 5. Popular Locations
          const Row(
            children: [
              Icon(Icons.location_city_rounded, color: Color(0xFFF59E0B), size: 18),
              SizedBox(width: 8),
              Text(
                'Popular Locations',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _popularCities.length,
              itemBuilder: (context, index) {
                final city = _popularCities[index];

                return GestureDetector(
                  onTap: () => widget.onSelectCity(city['name']!),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xCC152033),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0x33384AD0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          city['name']!,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          city['temp']!,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallDetailItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFF59E0B), size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
      ],
    );
  }
}
