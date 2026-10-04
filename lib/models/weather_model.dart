class CurrentWeather {
  final double temp;
  final double feelsLike;
  final double tempHigh;
  final double tempLow;
  final String condition;
  final int humidity;
  final String humidityLabel;
  final double windSpeed;
  final String windDirection;
  final int uvIndex;
  final String uvLabel;
  final int pressure;
  final double visibility;
  final int airQualityIndex;
  final String airQualityLabel;

  CurrentWeather({
    required this.temp,
    required this.feelsLike,
    required this.tempHigh,
    required this.tempLow,
    required this.condition,
    required this.humidity,
    required this.humidityLabel,
    required this.windSpeed,
    required this.windDirection,
    required this.uvIndex,
    required this.uvLabel,
    required this.pressure,
    required this.visibility,
    required this.airQualityIndex,
    required this.airQualityLabel,
  });
}

class HourlyForecast {
  final String time;
  final String label; // e.g. "Now", "4 PM"
  final double temp;
  final String condition;
  final int rainChance;
  final double windSpeed;

  HourlyForecast({
    required this.time,
    required this.label,
    required this.temp,
    required this.condition,
    required this.rainChance,
    required this.windSpeed,
  });
}

class DailyForecast {
  final String dayName; // e.g. "Today", "Tuesday"
  final String dateStr; // e.g. "18 Mar"
  final double tempHigh;
  final double tempLow;
  final String condition;
  final int rainChance;

  DailyForecast({
    required this.dayName,
    required this.dateStr,
    required this.tempHigh,
    required this.tempLow,
    required this.condition,
    required this.rainChance,
  });
}

class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final String severity; // "WARNING", "RESOLVED", "INFO"
  final String levelLabel; // "High", "Low", "Medium"
  final String affectedArea;
  final String validUntil;
  final bool isActive;

  WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.levelLabel,
    required this.affectedArea,
    required this.validUntil,
    required this.isActive,
  });
}

class WeatherData {
  final String locationName;
  final DateTime lastUpdated;
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final List<WeatherAlert> alerts;

  WeatherData({
    required this.locationName,
    required this.lastUpdated,
    required this.current,
    required this.hourly,
    required this.daily,
    required this.alerts,
  });
}
