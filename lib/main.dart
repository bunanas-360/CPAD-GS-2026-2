import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/citysense_provider.dart';
import 'services/local_storage_service.dart';
import 'services/weather_api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = CitySenseProvider(
    storage: LocalStorageService(),
    weatherApi: WeatherApiService(),
  );
  await provider.initialize(fetchWeather: false);
  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const CitySenseApp(),
    ),
  );
  unawaited(provider.refresh());
}
