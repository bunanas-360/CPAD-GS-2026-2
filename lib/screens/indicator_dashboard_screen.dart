import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/territory_data.dart';
import '../providers/citysense_provider.dart';
import '../widgets/app_notice.dart';
import '../widgets/metric_card.dart';
import '../widgets/section_title.dart';
import '../widgets/trend_chart.dart';

class IndicatorDashboardScreen extends StatelessWidget {
  const IndicatorDashboardScreen({super.key, required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<CitySenseProvider>();
    final weather = app.weather;
    final isClimate = type == 'climate';
    final isWater = type == 'water';
    final title = isClimate ? 'Clima e eventos extremos' : isWater ? 'Recursos hídricos' : 'Energia e serviços';
    final List<double> chartValues = isClimate
        ? (weather?.forecastTemperatures.isNotEmpty == true ? weather!.forecastTemperatures : WeatherSnapshot.demo().forecastTemperatures)
        : isWater
            ? const <double>[61.0, 64.0, 68.0, 72.0, 75.0, 79.0, 78.0]
            : const <double>[64.0, 67.0, 65.0, 72.0, 76.0, 81.0, 84.0];
    final chartTitle = isClimate ? 'Temperatura máxima prevista' : isWater ? 'Índice de pressão hídrica' : 'Índice de demanda energética';
    final chartUnit = isClimate ? '°C' : 'pontos / 100';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('SÃO PAULO • PAINEL TEMÁTICO', style: Theme.of(context).textTheme.labelMedium?.copyWith(letterSpacing: 1.5, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 8),
          Text(isClimate ? 'Condições atmosféricas' : isWater ? 'Uso e pressão sobre a água' : 'Demanda e capacidade de serviços', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          if (isClimate)
            AppNotice(message: weather?.isDemo == true ? 'Amostra climática demonstrativa. Conecte-se à internet para buscar dados atuais da Open-Meteo.' : app.isOfflineData ? 'Sem conexão: exibindo a última consulta climática salva localmente.' : 'Dados meteorológicos públicos obtidos da Open-Meteo para as coordenadas de referência de São Paulo.')
          else
            const AppNotice(message: 'Dados sintéticos para demonstração acadêmica. Não representam medições oficiais, consumo real ou operação de concessionárias.', warning: true),
          const SizedBox(height: 18),
          if (isClimate) ...[
            LayoutBuilder(builder: (context, constraints) {
              final width = (constraints.maxWidth - 12) / 2;
              return Wrap(spacing: 12, runSpacing: 12, children: [
                SizedBox(width: width, child: MetricCard(title: 'Temperatura atual', value: (weather?.temperature ?? 0).toStringAsFixed(1), unit: '°C', caption: 'Condição atual', icon: Icons.thermostat, accent: const Color(0xFFFFC46B))),
                SizedBox(width: width, child: MetricCard(title: 'Umidade', value: (weather?.humidity ?? 0).toStringAsFixed(0), unit: '%', caption: 'Umidade relativa', icon: Icons.water, accent: const Color(0xFF69A9FF))),
                SizedBox(width: width, child: MetricCard(title: 'Chuva prevista', value: (weather?.forecastRain ?? 0).toStringAsFixed(1), unit: 'mm', caption: 'Previsão do dia', icon: Icons.grain, accent: const Color(0xFF69A9FF))),
                SizedBox(width: width, child: MetricCard(title: 'Vento', value: (weather?.windSpeed ?? 0).toStringAsFixed(1), unit: 'km/h', caption: 'Velocidade atual', icon: Icons.air, accent: const Color(0xFF38D6C3))),
              ]);
            }),
          ] else if (isWater) ...[
            const MetricCard(title: 'Índice de pressão hídrica', value: '78', unit: '/100', caption: 'Indicador sintético', icon: Icons.water_drop_outlined, accent: Color(0xFF69A9FF)),
            const SizedBox(height: 12),
            MetricCard(title: 'Limite configurado', value: app.waterThreshold.toStringAsFixed(0), unit: '/100', caption: 'Pode ser alterado em Ajustes', icon: Icons.tune, accent: const Color(0xFF38D6C3)),
          ] else ...[
            const MetricCard(title: 'Pico de demanda energética', value: '84', unit: '/100', caption: 'Índice sintético', icon: Icons.bolt, accent: Color(0xFFFFC46B)),
            const SizedBox(height: 12),
            MetricCard(title: 'Limite configurado', value: app.energyThreshold.toStringAsFixed(0), unit: '/100', caption: 'Pode ser alterado em Ajustes', icon: Icons.tune, accent: const Color(0xFF38D6C3)),
            const SizedBox(height: 12),
            const MetricCard(title: 'Demanda por serviços comunitários', value: '67', unit: '/100', caption: 'Índice sintético demonstrativo', icon: Icons.groups_outlined, accent: Color(0xFF69A9FF)),
            const SizedBox(height: 12),
            MetricCard(title: 'Demandas comunitárias registradas', value: app.occurrences.length.toString(), unit: '', caption: 'Ocorrências locais cadastradas', icon: Icons.groups_outlined, accent: const Color(0xFF38D6C3)),
          ],
          const SizedBox(height: 22),
          SectionTitle(isClimate ? 'Previsão para os próximos 7 dias' : 'Tendência demonstrativa em 7 pontos'),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 16, 15, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chartTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(chartUnit, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 14),
                  TrendChart(values: chartValues, color: isClimate ? const Color(0xFFFFC46B) : isWater ? const Color(0xFF69A9FF) : const Color(0xFF38D6C3), unit: chartUnit),
                  const SizedBox(height: 8),
                  Text(isClimate ? 'Previsão diária de 7 dias fornecida pela API quando disponível.' : 'Série ilustrativa de sete pontos, construída para demonstrar visualização de tendência.', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle('Como interpretar'),
          Text(isClimate
              ? 'Temperatura, umidade, vento e precipitação ajudam a acompanhar condições ambientais. A previsão é regional e pode divergir das condições observadas em cada bairro.'
              : isWater
                  ? 'O índice hídrico é uma escala demonstrativa de pressão. Para planejamento real, deve ser substituído por séries autorizadas de abastecimento, consumo e perdas.'
                  : 'Os índices de energia e demanda comunitária são exemplos para demonstrar como séries operacionais poderiam apoiar planejamento. Não indicam capacidade real da rede.'),
          const SizedBox(height: 20),
          ElevatedButton.icon(onPressed: () => Navigator.pushNamed(context, '/alerts'), icon: const Icon(Icons.notifications_active_outlined), label: const Text('Ver alertas relacionados')),
        ],
      ),
    );
  }
}
