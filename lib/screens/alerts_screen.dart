import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/territory_data.dart';
import '../providers/citysense_provider.dart';
import '../widgets/app_notice.dart';
import '../widgets/section_title.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<CitySenseProvider>();
    final alerts = app.alerts;
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas preditivos')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const AppNotice(message: 'Os alertas são sinais de apoio à decisão. A validação por profissionais e a consulta a fontes oficiais são indispensáveis.'),
          const SizedBox(height: 16),
          SectionTitle('${alerts.length} alerta(s) identificado(s)'),
          const SizedBox(height: 10),
          if (app.isLoading && alerts.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
          else if (alerts.isEmpty)
            const _EmptyAlerts()
          else
            ...alerts.map((alert) => Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: _AlertCard(alert: alert),
                )),
          const SizedBox(height: 12),
          const Text('Confiança é um escore heurístico explicável, não uma probabilidade estatística calibrada. Os alertas de água e energia usam dados sintéticos.', style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});
  final AlertItem alert;

  @override
  Widget build(BuildContext context) {
    final color = switch (alert.severity) {
      AlertSeverity.critical => const Color(0xFFFF7676),
      AlertSeverity.attention => const Color(0xFFFFC46B),
      AlertSeverity.informational => const Color(0xFF69A9FF),
    };
    final level = switch (alert.severity) {
      AlertSeverity.critical => 'Crítico',
      AlertSeverity.attention => 'Atenção',
      AlertSeverity.informational => 'Informativo',
    };
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, '/alert-detail', arguments: alert),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(level.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 1.2)),
              const Spacer(),
              if (alert.isSimulated) const Text('SIMULADO', style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1)),
            ]),
            const SizedBox(height: 10),
            Text(alert.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text(alert.description, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.35)),
            const SizedBox(height: 13),
            Row(children: [
              Expanded(child: Text('${alert.category} • Confiança ${alert.confidence}%', style: const TextStyle(color: Colors.white54, fontSize: 11))),
              const Icon(Icons.arrow_forward, color: Colors.white54, size: 17),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _EmptyAlerts extends StatelessWidget {
  const _EmptyAlerts();
  @override
  Widget build(BuildContext context) => const Card(child: Padding(padding: EdgeInsets.all(24), child: Column(children: [Icon(Icons.check_circle_outline, size: 38, color: Color(0xFF38D6C3)), SizedBox(height: 10), Text('Nenhum alerta disponível'), Text('Atualize os dados ou confira os limiares configurados.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60))])));
}
