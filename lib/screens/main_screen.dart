import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/auth_service.dart';
import '../services/weather_service.dart';
import '../utils/time_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dashboard_screen.dart';
import 'hourly_forecast_screen.dart';
import 'login_screen.dart';
import 'radar_map_screen.dart';
import 'weather_alerts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoggedIn = false;
  int _currentIndex = 0;
  bool _isLoading = false;
  String _currentCity = "Mumbai, Maharashtra";
  final WeatherService _weatherService = WeatherService();
  final AuthService _authService = AuthService();
  WeatherData? _weatherData;

  // User info from login
  String _userEmail = '';
  String _userInitials = 'U';

  TimeOfDayCategory? _overrideTimeCategory;

  @override
  void initState() {
    super.initState();
    _checkExistingAuth();
    _loadData();
  }

  void _checkExistingAuth() {
    final user = _authService.currentUser;
    if (user != null && user.email != null) {
      final email = user.email!;
      final name = user.displayName ?? email.split('@').first;
      setState(() {
        _isLoggedIn = true;
        _userEmail = email;
        _userInitials = _getInitials(name, email);
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF2D82FE),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _loadData([String? city]) async {
    final bool isManualRefresh = city != null || _weatherData != null;
    if (city != null) {
      _currentCity = city.contains(',') ? city : "$city, India";
    }
    setState(() => _isLoading = true);
    try {
      final data = await _weatherService.fetchWeatherData(location: _currentCity);
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
      if (isManualRefresh) {
        _showSnackBar('Weather updated for ${data.locationName.split(',').first}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Failed to update weather', isError: true);
    }
  }

  TimeOfDayCategory get _currentCategory {
    if (_overrideTimeCategory != null) return _overrideTimeCategory!;
    final hour = DateTime.now().hour;
    return TimeTheme.getCategoryByHour(hour);
  }

  /// Extract initials from name or email (e.g. "Kinjal Gawali" → "KG", "kinjal@gmail.com" → "KG")
  String _getInitials(String name, String email) {
    if (name.isNotEmpty && name != email && !name.contains('@')) {
      final parts = name.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      if (name.length >= 2) {
        return name.substring(0, 2).toUpperCase();
      }
      return name[0].toUpperCase();
    }

    if (email.isEmpty) return 'U';
    final handle = email.split('@').first;
    final parts = handle.split(RegExp(r'[._]'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (handle.length >= 2) {
      return handle.substring(0, 2).toUpperCase();
    }
    return handle[0].toUpperCase();
  }

  void _showTimePickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Theme Accent (Viva Demo)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildThemeOption('Auto System Time', null),
              _buildThemeOption('Morning Sky', TimeOfDayCategory.morning),
              _buildThemeOption('Afternoon Sky', TimeOfDayCategory.afternoon),
              _buildThemeOption('Evening Sunset', TimeOfDayCategory.evening),
              _buildThemeOption('Night Skyview', TimeOfDayCategory.night),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(String title, TimeOfDayCategory? category) {
    final bool isSelected = _overrideTimeCategory == category;

    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Color(0xFFF59E0B)) : null,
      onTap: () {
        setState(() {
          _overrideTimeCategory = category;
        });
        Navigator.pop(context);
      },
    );
  }

  Future<void> _handleLogout() async {
    await _authService.signOut();
    setState(() {
      _isLoggedIn = false;
      _userEmail = '';
      _userInitials = 'U';
      _currentIndex = 0;
    });
    _showSnackBar('Logged out successfully');
  }

  @override
  Widget build(BuildContext context) {
    // Render Login Screen first if user is not logged in yet
    if (!_isLoggedIn) {
      return LoginScreen(
        onLoginSuccess: (String email, String name) {
          setState(() {
            _isLoggedIn = true;
            _userEmail = email;
            _userInitials = _getInitials(name, email);
          });
          _showSnackBar('Login successful! Welcome back, ${name.split(' ').first}.');
        },
      );
    }

    final category = _currentCategory;

    return Scaffold(
      backgroundColor: const Color(0xFF0B162C),
      body: Stack(
        children: [
          // Background Gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: TimeTheme.getBackgroundGradient(category),
            ),
          ),

          // Main Screen Pages
          if (_isLoading || _weatherData == null)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF59E0B),
              ),
            )
          else
            SafeArea(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  DashboardScreen(
                    weatherData: _weatherData!,
                    timeCategory: category,
                    onRefresh: () => _loadData(),
                    onNavigateTab: (idx) => setState(() => _currentIndex = idx),
                    onSelectCity: (city) => _loadData(city),
                    userInitials: _userInitials,
                    userEmail: _userEmail,
                    onLogout: _handleLogout,
                  ),
                  HourlyForecastScreen(
                    weatherData: _weatherData!,
                    timeCategory: category,
                    userInitials: _userInitials,
                    userEmail: _userEmail,
                    onLogout: _handleLogout,
                  ),
                  WeatherAlertsScreen(
                    weatherData: _weatherData!,
                    timeCategory: category,
                    userInitials: _userInitials,
                    userEmail: _userEmail,
                    onLogout: _handleLogout,
                  ),
                  RadarMapScreen(
                    weatherData: _weatherData!,
                    timeCategory: category,
                    userInitials: _userInitials,
                    userEmail: _userEmail,
                    onLogout: _handleLogout,
                  ),
                ],
              ),
            ),

          // Viva Demo Theme Selector
          Positioned(
            top: 48,
            right: 16,
            child: GestureDetector(
              onLongPress: _showTimePickerModal,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0x33FFFFFF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

