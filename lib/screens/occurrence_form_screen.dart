import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/citysense_provider.dart';

class OccurrenceFormScreen extends StatefulWidget {
  const OccurrenceFormScreen({super.key});

  @override
  State<OccurrenceFormScreen> createState() => _OccurrenceFormScreenState();
}

class _OccurrenceFormScreenState extends State<OccurrenceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _districtController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _category = 'Alagamento';
  bool _anonymousConsent = false;
  bool _saving = false;

  static const _categories = [
    'Alagamento',
    'Falta de água',
    'Iluminação pública',
    'Resíduos e limpeza',
    'Dano em via pública',
    'Outro',
  ];

  @override
  void dispose() {
    _districtController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  bool _containsPersonalData(String text) {
    final email = RegExp(r'\b[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}\b');
    final cpf = RegExp(r'\b\d{3}\.?\d{3}\.?\d{3}-?\d{2}\b');
    final phone = RegExp(
      r'(?<!\d)(?:\+?55\s?)?(?:\(?\d{2}\)?\s?)?(?:9\d{4}|[2-8]\d{3})[-.\s]?\d{4}(?!\d)',
    );
    return email.hasMatch(text) || cpf.hasMatch(text) || phone.hasMatch(text);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_anonymousConsent) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Confirme o uso anônimo da informação para continuar.')));
      return;
    }
    setState(() => _saving = true);
    try {
      await context.read<CitySenseProvider>().saveOccurrence(
            category: _category,
            district: _districtController.text,
            description: _descriptionController.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ocorrência salva neste dispositivo.')));
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível salvar: $error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar ocorrência')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text('Ajude a compreender o território', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Registre um problema de forma anônima. Os dados ficam salvos localmente no aparelho e podem ser usados como histórico demonstrativo.', style: TextStyle(color: Colors.white70, height: 1.4)),
            const SizedBox(height: 20),
            const Text('Categoria', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(),
              items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
              onChanged: (value) => setState(() => _category = value ?? _category),
            ),
            const SizedBox(height: 16),
            const Text('Bairro ou região', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _districtController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Ex.: Vila Mariana'),
              maxLength: 60,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.length < 3) return 'Informe um bairro ou região com pelo menos 3 caracteres.';
                if (text.length > 60) return 'Use no máximo 60 caracteres.';
                return null;
              },
            ),
            const SizedBox(height: 10),
            const Text('Descrição do problema', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              minLines: 4,
              maxLines: 6,
              maxLength: 500,
              decoration: const InputDecoration(hintText: 'Descreva o que aconteceu, sem incluir nomes, telefones ou dados pessoais.'),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.length < 15) return 'Descreva o problema com pelo menos 15 caracteres.';
                if (text.length > 500) return 'Use no máximo 500 caracteres.';
                if (_containsPersonalData(text)) {
                  return 'Remova e-mail, CPF ou telefone. O relato deve ser anônimo.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Card(
              child: CheckboxListTile(
                value: _anonymousConsent,
                onChanged: (value) => setState(() => _anonymousConsent = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Concordo com o registro anônimo desta ocorrência.'),
                subtitle: const Text('Não informe dados pessoais nem endereço exato. O envio é local e não transmite a ocorrência a órgãos públicos.'),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Salvando...' : 'Salvar ocorrência'),
            ),
          ],
        ),
      ),
    );
  }
}
