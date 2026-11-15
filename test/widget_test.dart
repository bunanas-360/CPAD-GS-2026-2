import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:citysense/app.dart';
import 'package:citysense/providers/citysense_provider.dart';
import 'package:citysense/services/local_storage_service.dart';
import 'package:citysense/services/weather_api_service.dart';

void main() {
  testWidgets('exibe a tela de consentimento ao iniciar o CitySense', (tester) async {
    final provider = CitySenseProvider(
      storage: LocalStorageService(),
      weatherApi: WeatherApiService(),
    );
    addTearDown(provider.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider<CitySenseProvider>.value(
        value: provider,
        child: const CitySenseApp(),
      ),
    );

    expect(find.text('CITYSENSE'), findsOneWidget);
    expect(find.text('Continuar para o painel'), findsOneWidget);
  });
}
