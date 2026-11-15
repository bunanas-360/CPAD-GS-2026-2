import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/territory_data.dart';

class LocalStorageService {
  Database? _database;
  SharedPreferences? _preferences;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    final databasePath = await getDatabasesPath();
    _database = await openDatabase(
      p.join(databasePath, 'citysense.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE occurrences (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT NOT NULL,
            district TEXT NOT NULL,
            description TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  SharedPreferences get _prefs {
    final value = _preferences;
    if (value == null) throw StateError('Storage ainda não foi inicializado.');
    return value;
  }

  Database get _db {
    final value = _database;
    if (value == null) throw StateError('Banco ainda não foi inicializado.');
    return value;
  }

  bool get consentAccepted => _prefs.getBool('consentAccepted') ?? false;
  Future<void> saveConsent(bool value) =>
      _prefs.setBool('consentAccepted', value);

  bool get highContrast => _prefs.getBool('highContrast') ?? false;
  Future<void> saveHighContrast(bool value) =>
      _prefs.setBool('highContrast', value);

  double get waterThreshold => _prefs.getDouble('waterThreshold') ?? 75;
  double get energyThreshold => _prefs.getDouble('energyThreshold') ?? 80;

  Future<void> saveThresholds({
    required double water,
    required double energy,
  }) async {
    await _prefs.setDouble('waterThreshold', water);
    await _prefs.setDouble('energyThreshold', energy);
  }

  Future<void> saveWeather(WeatherSnapshot snapshot) async {
    await _prefs.setString('weatherCache', jsonEncode(snapshot.toJson()));
  }

  WeatherSnapshot? readWeather() {
    final raw = _prefs.getString('weatherCache');
    if (raw == null) return null;
    try {
      return WeatherSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<int> insertOccurrence(Occurrence occurrence) async =>
      _db.insert('occurrences', occurrence.toMap());

  Future<List<Occurrence>> listOccurrences() async {
    final rows = await _db.query('occurrences', orderBy: 'createdAt DESC');
    return rows.map(Occurrence.fromMap).toList();
  }
}
