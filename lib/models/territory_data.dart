class WeatherSnapshot {
  const WeatherSnapshot({
    required this.temperature,
    required this.precipitation,
    required this.humidity,
    required this.windSpeed,
    required this.forecastRain,
    required this.forecastMaxTemperature,
    required this.forecastMinTemperature,
    required this.forecastTemperatures,
    required this.forecastPrecipitations,
    required this.updatedAt,
    required this.isDemo,
  });

  final double temperature;
  final double precipitation;
  final double humidity;
  final double windSpeed;
  final double forecastRain;
  final double forecastMaxTemperature;
  final double forecastMinTemperature;
  final List<double> forecastTemperatures;
  final List<double> forecastPrecipitations;
  final DateTime updatedAt;
  final bool isDemo;

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'precipitation': precipitation,
        'humidity': humidity,
        'windSpeed': windSpeed,
        'forecastRain': forecastRain,
        'forecastMaxTemperature': forecastMaxTemperature,
        'forecastMinTemperature': forecastMinTemperature,
        'forecastTemperatures': forecastTemperatures,
        'forecastPrecipitations': forecastPrecipitations,
        'updatedAt': updatedAt.toIso8601String(),
        'isDemo': isDemo,
      };

  factory WeatherSnapshot.fromJson(Map<String, dynamic> json) {
    return WeatherSnapshot(
      temperature: (json['temperature'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      forecastRain: (json['forecastRain'] as num).toDouble(),
      forecastMaxTemperature:
          (json['forecastMaxTemperature'] as num).toDouble(),
      forecastMinTemperature:
          (json['forecastMinTemperature'] as num).toDouble(),
      forecastTemperatures: (json['forecastTemperatures'] as List<dynamic>? ?? const []).map((v) => (v as num).toDouble()).toList(),
      forecastPrecipitations: (json['forecastPrecipitations'] as List<dynamic>? ?? const []).map((v) => (v as num).toDouble()).toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDemo: json['isDemo'] as bool? ?? false,
    );
  }

  factory WeatherSnapshot.demo() => WeatherSnapshot(
        temperature: 28.4,
        precipitation: 0,
        humidity: 58,
        windSpeed: 13.2,
        forecastRain: 12,
        forecastMaxTemperature: 33,
        forecastMinTemperature: 21,
        forecastTemperatures: const [29, 31, 33, 30, 28, 27, 29],
        forecastPrecipitations: const [0, 0, 12, 18, 4, 0, 2],
        updatedAt: DateTime.now(),
        isDemo: true,
      );
}

class AlertItem {
  const AlertItem({
    required this.id,
    required this.title,
    required this.category,
    required this.severity,
    required this.description,
    required this.evidence,
    required this.confidence,
    required this.limitations,
    required this.recommendedAction,
    required this.isSimulated,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String category;
  final AlertSeverity severity;
  final String description;
  final String evidence;
  /// Heuristic score based on rule evidence; it is NOT a calibrated probability.
  final int confidence;
  final String limitations;
  final String recommendedAction;
  final bool isSimulated;
  final DateTime createdAt;
}

enum AlertSeverity { critical, attention, informational }

class Occurrence {
  const Occurrence({
    required this.id,
    required this.category,
    required this.district,
    required this.description,
    required this.createdAt,
  });

  final int? id;
  final String category;
  final String district;
  final String description;
  final DateTime createdAt;

  Map<String, Object?> toMap() => {
        'id': id,
        'category': category,
        'district': district,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Occurrence.fromMap(Map<String, Object?> map) => Occurrence(
        id: map['id'] as int?,
        category: map['category'] as String,
        district: map['district'] as String,
        description: map['description'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}
