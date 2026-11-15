import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/citysense_provider.dart';
import '../services/alert_engine.dart';
import '../widgets/app_notice.dart';
import '../widgets/metric_card.dart';
import '../widgets/section_title.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<CitySenseProvider>();
    final weather = app.weather;

    if (weather == null && app.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CitySense'),
        actions: [
          IconButton(
            tooltip: 'Atualizar dados',
            onPressed: app.isLoading ? null : app.refresh,
            icon: app.isLoading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
          ),
          IconButton(tooltip: 'Configurações', onPressed: () => Navigator.pushNamed(context, '/settings'), icon: const Icon(Icons.tune)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: app.refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
          children: [
            Text('PAINEL TERRITORIAL', style: Theme.of(context).textTheme.labelMedium?.copyWith(letterSpacing: 2, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text('São Paulo, SP', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('Leitura integrada de clima, recursos e serviços.', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 18),
            if (app.errorMessage != null)
              AppNotice(message: app.errorMessage!, warning: true)
            else if (app.isOfflineData)
              const AppNotice(message: 'Modo offline: exibindo o último dado salvo ou uma amostra local demonstrativa.'),
            const AppNotice(message: 'Os alertas apoiam a análise. A decisão final é sempre humana e deve considerar fontes oficiais.'),
            const SizedBox(height: 22),
            const SectionTitle('Indicadores em destaque'),
            const SizedBox(height: 10),
            LayoutBuilder(builder: (context, constraints) {
              final width = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: width,
                    child: MetricCard(
                      title: 'Temperatura atual',
                      value: weather?.temperature.toStringAsFixed(1) ?? '--',
                      unit: '°C',
                      caption: weather?.isDemo == true ? 'Amostra demonstrativa' : app.isOfflineData ? 'Última consulta salva' : 'Open-Meteo • atual',
                      icon: Icons.thermostat,
                      accent: const Color(0xFFFFC46B),
                      onTap: () => Navigator.pushNamed(context, '/indicator', arguments: 'climate'),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: MetricCard(
                      title: 'Pressão hídrica',
                      value: AlertEngine.waterIndex.toStringAsFixed(0),
                      unit: '/100',
                      caption: 'Índice sintético',
                      icon: Icons.water_drop_outlined,
                      accent: const Color(0xFF69A9FF),
                      onTap: () => Navigator.pushNamed(context, '/indicator', arguments: 'water'),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: MetricCard(
                      title: 'Demanda energética',
                      value: AlertEngine.energyPeakIndex.toStringAsFixed(0),
                      unit: '/100',
                      caption: 'Índice sintético',
                      icon: Icons.bolt,
                      accent: const Color(0xFFFFC46B),
                      onTap: () => Navigator.pushNamed(context, '/indicator', arguments: 'services'),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: MetricCard(
                      title: 'Alertas ativos',
                      value: app.activeAlertCount.toString(),
                      unit: '',
                      caption: 'Requerem avaliação humana',
                      icon: Icons.notifications_active_outlined,
                      accent: const Color(0xFFFF7676),
                      onTap: () => Navigator.pushNamed(context, '/alerts'),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 22),
            const SectionTitle('Dashboards territoriais'),
            const SizedBox(height: 10),
            _DashboardLink(
              icon: Icons.cloud_outlined,
              title: 'Clima e eventos extremos',
              subtitle: 'Temperatura, chuva, umidade e vento',
              color: const Color(0xFF69A9FF),
              onTap: () => Navigator.pushNamed(context, '/indicator', arguments: 'climate'),
            ),
            const SizedBox(height: 9),
            _DashboardLink(
              icon: Icons.water_drop_outlined,
              title: 'Recursos hídricos',
              subtitle: 'Pressão de consumo e tendência demonstrativa',
              color: const Color(0xFF38D6C3),
              onTap: () => Navigator.pushNamed(context, '/indicator', arguments: 'water'),
            ),
            const SizedBox(height: 9),
            _DashboardLink(
              icon: Icons.bolt,
              title: 'Energia e serviços',
              subtitle: 'Pico de demanda e procura comunitária',
              color: const Color(0xFFFFC46B),
              onTap: () => Navigator.pushNamed(context, '/indicator', arguments: 'services'),
            ),
            const SizedBox(height: 22),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Row(
                  children: [
                    Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFF38D6C3).withValues(alpha: .14), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.volunteer_activism, color: Color(0xFF38D6C3))),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Indicador de benefício social', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Text('${app.occurrences.length} ocorrência(s) comunitária(s) registrada(s) para apoiar a análise da gestão.', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 3),
                        const Text('Indicador de participação comunitária; não comprova impacto final.', style: TextStyle(color: Colors.white54, fontSize: 10)),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const SectionTitle('Ações da comunidade'),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/occurrence'),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Registrar ocorrência no território'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/alerts'),
              icon: const Icon(Icons.notifications_none),
              label: const Text('Consultar justificativas dos alertas'),
            ),
            const SizedBox(height: 6),
            Text('Atualização: ${weather?.updatedAt.toLocal().toString().substring(0, 16) ?? 'sem dados'}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) Navigator.pushNamed(context, '/alerts');
          if (index == 2) Navigator.pushNamed(context, '/occurrence');
          if (index == 3) Navigator.pushNamed(context, '/settings');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), label: 'Alertas'),
          NavigationDestination(icon: Icon(Icons.add_location_alt_outlined), label: 'Ocorrência'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
        ],
      ),
    );
  }
}

class _DashboardLink extends StatelessWidget {
  const _DashboardLink({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          minVerticalPadding: 13,
          leading: CircleAvatar(backgroundColor: color.withValues(alpha: .14), child: Icon(icon, color: color)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
          onTap: onTap,
        ),
      );
}
