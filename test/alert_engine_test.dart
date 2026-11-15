import 'package:flutter_test/flutter_test.dart';
import 'package:citysense/models/territory_data.dart';
import 'package:citysense/services/alert_engine.dart';

void main() {
  group('AlertEngine', () {
    test('gera alertas explicáveis para índices sintéticos acima dos limites', () {
      final engine = AlertEngine();
      final alerts = engine.generate(
        weather: WeatherSnapshot.demo(),
        waterThreshold: 70,
        energyThreshold: 80,
      );

      expect(alerts.any((alert) => alert.category == 'Água'), isTrue);
      expect(alerts.any((alert) => alert.category == 'Energia'), isTrue);
      expect(alerts.every((alert) => alert.evidence.isNotEmpty), isTrue);
      expect(alerts.every((alert) => alert.limitations.isNotEmpty), isTrue);
      expect(alerts.every((alert) => alert.confidence >= 0 && alert.confidence <= 100), isTrue);
    });

    test('inclui alerta climático quando a máxima prevista é igual ou superior a 32 °C', () {
      final engine = AlertEngine();
      final alerts = engine.generate(
        weather: WeatherSnapshot.demo(),
        waterThreshold: 100,
        energyThreshold: 100,
      );

      expect(alerts.any((alert) => alert.category == 'Clima'), isTrue);
    });

    test('retorna lista vazia quando nenhuma regra é acionada', () {
      final mildWeather = WeatherSnapshot(
        temperature: 20,
        precipitation: 0,
        humidity: 50,
        windSpeed: 8,
        forecastRain: 5,
        forecastMaxTemperature: 25,
        forecastMinTemperature: 16,
        forecastTemperatures: [22, 23, 24, 25, 22, 21, 20],
        forecastPrecipitations: [0, 0, 0, 2, 0, 0, 3],
        updatedAt: DateTime.utc(2026, 1, 1),
        isDemo: false,
      );
      final alerts = AlertEngine().generate(
        weather: mildWeather,
        waterThreshold: 90,
        energyThreshold: 90,
      );

      expect(alerts, isEmpty);
    });
  });
}
