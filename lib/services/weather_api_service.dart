import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/territory_data.dart';

class WeatherApiService {
  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _latitude = -23.5505;
  static const _longitude = -46.6333;

  Future<WeatherSnapshot> fetchSaoPauloWeather() async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$_latitude',
      'longitude': '$_longitude',
      'current':
          'temperature_2m,precipitation,relative_humidity_2m,wind_speed_10m',
      'daily': 'precipitation_sum,temperature_2m_max,temperature_2m_min',
      'forecast_days': '7',
      'timezone': 'America/Sao_Paulo',
    });

    final response = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw Exception('A API climática respondeu com status ${response.statusCode}.');
    }

    final root = jsonDecode(response.body) as Map<String, dynamic>;
    final current = root['current'] as Map<String, dynamic>?;
    final daily = root['daily'] as Map<String, dynamic>?;
    if (current == null || daily == null) {
      throw const FormatException('A resposta da API não contém os campos esperados.');
    }

    double number(dynamic value) {
      if (value is num) return value.toDouble();
      throw const FormatException('A API retornou um valor numérico inválido.');
    }

    final rain = (daily['precipitation_sum'] as List<dynamic>?) ?? const [];
    final max = (daily['temperature_2m_max'] as List<dynamic>?) ?? const [];
    final min = (daily['temperature_2m_min'] as List<dynamic>?) ?? const [];
    if (rain.isEmpty || max.isEmpty || min.isEmpty) {
      throw const FormatException('A previsão diária está incompleta.');
    }

    return WeatherSnapshot(
      temperature: number(current['temperature_2m']),
      precipitation: number(current['precipitation']),
      humidity: number(current['relative_humidity_2m']),
      windSpeed: number(current['wind_speed_10m']),
      forecastRain: number(rain.first),
      forecastMaxTemperature: number(max.first),
      forecastMinTemperature: number(min.first),
      forecastTemperatures: max.map(number).toList(),
      forecastPrecipitations: rain.map(number).toList(),
      updatedAt: DateTime.now(),
      isDemo: false,
    );
  }

  void dispose() => _client.close();
}
