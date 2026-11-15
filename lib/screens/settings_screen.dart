import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/citysense_provider.dart';
import '../widgets/app_notice.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _waterController;
  late final TextEditingController _energyController;

  @override
  void initState() {
    super.initState();
    final app = context.read<CitySenseProvider>();
    _waterController = TextEditingController(text: app.waterThreshold.toStringAsFixed(0));
    _energyController = TextEditingController(text: app.energyThreshold.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _waterController.dispose();
    _energyController.dispose();
    super.dispose();
  }

  String? _validateLimit(String? value) {
    final number = double.tryParse((value ?? '').replaceAll(',', '.'));
    if (number == null) return 'Informe um número válido.';
    if (number < 0 || number > 100) return 'O limite deve ficar entre 0 e 100.';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<CitySenseProvider>().saveThresholds(
          water: double.parse(_waterController.text.replaceAll(',', '.')),
          energy: double.parse(_energyController.text.replaceAll(',', '.')),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Limites atualizados e salvos localmente.')));
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<CitySenseProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Limites para alertas', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
          const SizedBox(height: 6),
          const Text('Altere os limiares dos índices demonstrativos. A atualização dos limites altera as regras de alerta imediatamente.', style: TextStyle(color: Colors.white70, height: 1.4)),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(controller: _waterController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Limite de pressão hídrica', suffixText: '/100'), validator: _validateLimit),
              const SizedBox(height: 14),
              TextFormField(controller: _energyController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Limite de demanda energética', suffixText: '/100'), validator: _validateLimit),
              const SizedBox(height: 14),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _save, child: const Text('Salvar limites'))),
            ]),
          ),
          const SizedBox(height: 23),
          const Text('Acessibilidade', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Alto contraste'),
            subtitle: const Text('Aumenta o destaque entre fundo e elementos da interface.'),
            value: app.highContrast,
            onChanged: app.setHighContrast,
          ),
          const SizedBox(height: 18),
          const Text('Privacidade e dados', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
          const SizedBox(height: 10),
          const AppNotice(message: 'O app não pede nome, telefone ou documento. Ocorrências são armazenadas no SQLite local. A API Open-Meteo recebe apenas coordenadas públicas de referência de São Paulo; o app não envia dados pessoais.'),
          const SizedBox(height: 14),
          const AppNotice(message: 'Água, energia e demanda comunitária usam séries sintéticas. Os alertas são regras explicáveis e não executam decisões automáticas.', warning: true),
          const SizedBox(height: 20),
          const Text('Sobre o projeto', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
          const SizedBox(height: 7),
          const Text('CitySense • Territory Predictive Insights\nGlobal Solution 2026.2 • FIAP\nAuro Vanetti de Moura Andrade — RM 563761\nRenan Mano Otero — RM 554911', style: TextStyle(color: Colors.white70, height: 1.6)),
        ],
      ),
    );
  }
}
