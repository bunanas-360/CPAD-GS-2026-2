import 'package:flutter/foundation.dart';

import '../models/territory_data.dart';
import '../services/alert_engine.dart';
import '../services/local_storage_service.dart';
import '../services/weather_api_service.dart';

class CitySenseProvider extends ChangeNotifier {
  CitySenseProvider({
    required LocalStorageService storage,
    required WeatherApiService weatherApi,
    AlertEngine? alertEngine,
  })  : _storage = storage,
        _weatherApi = weatherApi,
        _alertEngine = alertEngine ?? AlertEngine();

  final LocalStorageService _storage;
  final WeatherApiService _weatherApi;
  final AlertEngine _alertEngine;

  bool initialized = false;
  bool isLoading = false;
  bool isOfflineData = false;
  bool consentAccepted = false;
  bool highContrast = false;
  String? errorMessage;
  WeatherSnapshot? weather;
  List<Occurrence> occurrences = [];
  double waterThreshold = 75;
  double energyThreshold = 80;

  List<AlertItem> get alerts => weather == null
      ? const []
      : _alertEngine.generate(
          weather: weather!,
          waterThreshold: waterThreshold,
          energyThreshold: energyThreshold,
        );

  int get activeAlertCount => alerts
      .where((alert) => alert.severity != AlertSeverity.informational)
      .length;

  /// Potential social benefit indicator: preventive notices generated for
  /// human review. This is not a measured reduction in incidents.

  Future<void> initialize({bool fetchWeather = true}) async {
    if (initialized) return;
    await _storage.initialize();
    consentAccepted = _storage.consentAccepted;
    highContrast = _storage.highContrast;
    waterThreshold = _storage.waterThreshold;
    energyThreshold = _storage.energyThreshold;
    occurrences = await _storage.listOccurrences();
    weather = _storage.readWeather();
    initialized = true;
    notifyListeners();
    if (fetchWeather) await refresh();
  }

  Future<void> acceptConsent() async {
    await _storage.saveConsent(true);
    consentAccepted = true;
    notifyListeners();
  }

  Future<void> refresh() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final fresh = await _weatherApi.fetchSaoPauloWeather();
      weather = fresh;
      isOfflineData = false;
      await _storage.saveWeather(fresh);
    } catch (error) {
      final cached = _storage.readWeather();
      if (cached != null) {
        weather = cached;
        isOfflineData = true;
      } else {
        weather = WeatherSnapshot.demo();
        isOfflineData = true;
      }
      errorMessage =
          'Não foi possível atualizar os dados climáticos. Exibindo ${cached != null ? 'o último dado salvo' : 'dados demonstrativos locais'}. Detalhe: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveOccurrence({
    required String category,
    required String district,
    required String description,
  }) async {
    final occurrence = Occurrence(
      id: null,
      category: category,
      district: district.trim(),
      description: description.trim(),
      createdAt: DateTime.now(),
    );
    await _storage.insertOccurrence(occurrence);
    occurrences = await _storage.listOccurrences();
    notifyListeners();
  }

  Future<void> saveThresholds({
    required double water,
    required double energy,
  }) async {
    waterThreshold = water;
    energyThreshold = energy;
    await _storage.saveThresholds(water: water, energy: energy);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    highContrast = value;
    await _storage.saveHighContrast(value);
    notifyListeners();
  }

  @override
  void dispose() {
    _weatherApi.dispose();
    super.dispose();
  }
}
