import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/territory_data.dart';
import 'providers/citysense_provider.dart';
import 'screens/alert_detail_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/indicator_dashboard_screen.dart';
import 'screens/occurrence_form_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';

class CitySenseApp extends StatelessWidget {
  const CitySenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CitySenseProvider>(
      builder: (context, app, _) => MaterialApp(
        title: 'CitySense',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(highContrast: app.highContrast),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (_) => app.consentAccepted
                    ? const DashboardScreen()
                    : const ConsentScreen(),
              );
            case '/consent':
              return MaterialPageRoute<void>(builder: (_) => const ConsentScreen());
            case '/dashboard':
              return MaterialPageRoute<void>(builder: (_) => const DashboardScreen());
            case '/indicator':
              final type = settings.arguments as String? ?? 'climate';
              return MaterialPageRoute<void>(builder: (_) => IndicatorDashboardScreen(type: type));
            case '/alerts':
              return MaterialPageRoute<void>(builder: (_) => const AlertsScreen());
            case '/alert-detail':
              final alert = settings.arguments;
              if (alert is! AlertItem) return _invalidRoute();
              return MaterialPageRoute<void>(builder: (_) => AlertDetailScreen(alert: alert));
            case '/occurrence':
              return MaterialPageRoute<void>(builder: (_) => const OccurrenceFormScreen());
            case '/settings':
              return MaterialPageRoute<void>(builder: (_) => const SettingsScreen());
            default:
              return _invalidRoute();
          }
        },
      ),
    );
  }

  MaterialPageRoute<void> _invalidRoute() => MaterialPageRoute<void>(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Tela não encontrada. Volte ao painel inicial.')),
        ),
      );
}
