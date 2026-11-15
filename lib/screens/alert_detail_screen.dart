import 'package:flutter/material.dart';

import '../models/territory_data.dart';
import '../widgets/app_notice.dart';

class AlertDetailScreen extends StatelessWidget {
  const AlertDetailScreen({super.key, required this.alert});
  final AlertItem alert;

  @override
  Widget build(BuildContext context) {
    final color = switch (alert.severity) {
      AlertSeverity.critical => const Color(0xFFFF7676),
      AlertSeverity.attention => const Color(0xFFFFC46B),
      AlertSeverity.informational => const Color(0xFF69A9FF),
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe do alerta')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 8), Text(alert.category.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.w800, letterSpacing: 1.4, fontSize: 11))]),
          const SizedBox(height: 12),
          Text(alert.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          const AppNotice(message: 'Este alerta é uma recomendação de análise. Nenhuma ação automática é executada; a decisão final pertence às pessoas responsáveis.'),
          const SizedBox(height: 20),
          _DetailBlock(title: 'O que foi identificado', content: alert.description),
          _DetailBlock(title: 'Evidências utilizadas', content: alert.evidence),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Nível de confiança operacional', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('${alert.confidence}%', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(width: 8), const Padding(padding: EdgeInsets.only(bottom: 6), child: Text('escore heurístico', style: TextStyle(color: Colors.white60)))]),
                const SizedBox(height: 10),
                ClipRRect(borderRadius: BorderRadius.circular(9), child: LinearProgressIndicator(value: alert.confidence / 100, minHeight: 8, backgroundColor: Colors.white12, color: color)),
                const SizedBox(height: 10),
                const Text('O número representa uma pontuação baseada na presença e na consistência das regras observadas. Não foi calibrado como probabilidade estatística.', style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.35)),
              ]),
            ),
          ),
          _DetailBlock(title: 'Limitações e quando não confiar', content: alert.limitations),
          _DetailBlock(title: 'Ação sugerida para avaliação humana', content: alert.recommendedAction),
          const SizedBox(height: 8),
          if (alert.isSimulated) const AppNotice(message: 'Parte das evidências deste alerta utiliza dados sintéticos ou uma amostra local. Não use como diagnóstico de uma situação real.', warning: true),
          const SizedBox(height: 18),
          OutlinedButton.icon(onPressed: () => Navigator.pushNamed(context, '/occurrence'), icon: const Icon(Icons.add_location_alt_outlined), label: const Text('Registrar ocorrência relacionada')),
        ],
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 7),
          Text(content, style: const TextStyle(color: Colors.white70, height: 1.45)),
        ]),
      );
}
