import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/citysense_provider.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.location_city, size: 34, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 26),
                  Text('CITYSENSE', style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 3, color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 10),
                  Text('Inteligência territorial para decisões melhores.', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, height: 1.15)),
                  const SizedBox(height: 18),
                  const Text('O CitySense reúne indicadores territoriais, tendências e alertas explicáveis para apoiar gestores e cidadãos. Os alertas não substituem a avaliação humana nem orientações oficiais.'),
                  const SizedBox(height: 24),
                  const _PrivacyPoint(icon: Icons.visibility_outlined, text: 'Transparência: cada alerta apresenta evidências, nível de confiança operacional e limitações.'),
                  const _PrivacyPoint(icon: Icons.lock_outline, text: 'Privacidade: o formulário não solicita nome, telefone, documento ou endereço exato.'),
                  const _PrivacyPoint(icon: Icons.storage_outlined, text: 'Persistência: ocorrências e preferências ficam armazenadas localmente neste dispositivo.'),
                  const _PrivacyPoint(icon: Icons.science_outlined, text: 'Dados: clima pode vir de API pública; água e energia são dados demonstrativos sintéticos.'),
                  const SizedBox(height: 24),
                  Card(
                    child: CheckboxListTile(
                      value: accepted,
                      onChanged: (value) => setState(() => accepted = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Li e concordo com o uso dos dados descrito acima.'),
                      subtitle: const Text('O consentimento é salvo localmente e pode ser revisto nas informações do aplicativo.'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: accepted
                          ? () async {
                              await context.read<CitySenseProvider>().acceptConsent();
                              if (!context.mounted) return;
                              Navigator.pushReplacementNamed(context, '/dashboard');
                            }
                          : null,
                      child: const Text('Continuar para o painel'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(child: Text('Projeto acadêmico • FIAP • Global Solution 2026.2', style: TextStyle(color: Colors.white54, fontSize: 11))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrivacyPoint extends StatelessWidget {
  const _PrivacyPoint({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 21),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
          ],
        ),
      );
}
