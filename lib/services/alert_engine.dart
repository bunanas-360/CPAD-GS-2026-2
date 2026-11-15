import '../models/territory_data.dart';

class AlertEngine {
  static const double waterIndex = 78;
  static const double energyPeakIndex = 84;

  List<AlertItem> generate({
    required WeatherSnapshot weather,
    required double waterThreshold,
    required double energyThreshold,
  }) {
    final alerts = <AlertItem>[];

    if (weather.forecastMaxTemperature >= 32) {
      alerts.add(AlertItem(
        id: 'heat-${weather.updatedAt.day}',
        title: 'Calor intenso previsto',
        category: 'Clima',
        severity: weather.forecastMaxTemperature >= 36
            ? AlertSeverity.critical
            : AlertSeverity.attention,
        description:
            'A temperatura máxima prevista para o território pode aumentar a exposição ao calor.',
        evidence:
            'Previsão Open-Meteo: máxima de ${weather.forecastMaxTemperature.toStringAsFixed(1)} °C; temperatura atual de ${weather.temperature.toStringAsFixed(1)} °C.',
        confidence: 82,
        limitations:
            'Índice heurístico, não probabilidade estatística calibrada. A previsão pode mudar e não representa a temperatura de cada rua ou residência.',
        recommendedAction:
            'Avaliar comunicação preventiva, hidratação e atenção a grupos vulneráveis. A gestão pública deve validar a situação antes de agir.',
        isSimulated: weather.isDemo,
        createdAt: weather.updatedAt,
      ));
    }

    if (weather.forecastRain >= 40) {
      alerts.add(AlertItem(
        id: 'rain-${weather.updatedAt.day}',
        title: 'Volume elevado de chuva previsto',
        category: 'Clima e drenagem',
        severity: weather.forecastRain >= 70
            ? AlertSeverity.critical
            : AlertSeverity.attention,
        description:
            'O volume diário previsto pode pressionar sistemas de drenagem e áreas suscetíveis a alagamentos.',
        evidence:
            'Precipitação diária prevista: ${weather.forecastRain.toStringAsFixed(1)} mm.',
        confidence: 74,
        limitations:
            'A previsão é agregada para o ponto de referência de São Paulo. Não substitui medições locais, mapas de risco ou avisos oficiais.',
        recommendedAction:
            'Conferir boletins oficiais e pontos historicamente vulneráveis. Não bloquear vias nem deslocar equipes apenas com base neste alerta.',
        isSimulated: weather.isDemo,
        createdAt: weather.updatedAt,
      ));
    }

    if (waterIndex >= waterThreshold) {
      alerts.add(AlertItem(
        id: 'water-pressure',
        title: 'Pressão de consumo hídrico',
        category: 'Água',
        severity: waterIndex >= waterThreshold + 8
            ? AlertSeverity.critical
            : AlertSeverity.attention,
        description:
            'O índice demonstrativo de pressão hídrica ultrapassou o limite configurado.',
        evidence:
            'Índice de pressão hídrica: ${waterIndex.toStringAsFixed(0)}/100; limite configurado: ${waterThreshold.toStringAsFixed(0)}/100.',
        confidence: 68,
        limitations:
            'Indicador sintético para demonstração acadêmica. Não representa consumo medido da Sabesp nem consumo real por bairro.',
        recommendedAction:
            'Investigar possíveis perdas e comparar com dados operacionais oficiais antes de priorizar intervenções.',
        isSimulated: true,
        createdAt: DateTime.now(),
      ));
    }

    if (energyPeakIndex >= energyThreshold) {
      alerts.add(AlertItem(
        id: 'energy-peak',
        title: 'Pico de demanda energética',
        category: 'Energia',
        severity: energyPeakIndex >= energyThreshold + 8
            ? AlertSeverity.critical
            : AlertSeverity.attention,
        description:
            'O índice demonstrativo de demanda está acima do limiar definido.',
        evidence:
            'Índice demonstrativo de demanda: ${energyPeakIndex.toStringAsFixed(0)}/100; limite configurado: ${energyThreshold.toStringAsFixed(0)}/100.',
        confidence: 65,
        limitations:
            'Índice sintético, não conectado a medidores ou concessionárias. Não estima carga elétrica real.',
        recommendedAction:
            'Usar o sinal como hipótese de análise e validar com dados de consumo e capacidade da rede.',
        isSimulated: true,
        createdAt: DateTime.now(),
      ));
    }


    alerts.sort((a, b) => _priority(b.severity).compareTo(_priority(a.severity)));
    return alerts;
  }

  int _priority(AlertSeverity severity) => switch (severity) {
        AlertSeverity.critical => 3,
        AlertSeverity.attention => 2,
        AlertSeverity.informational => 1,
      };
}
