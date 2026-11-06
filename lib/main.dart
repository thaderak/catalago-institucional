import 'package:flutter/material.dart';
import 'models/component_item.dart';
import 'screens/details_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CatalogoSenatiApp());
}

/// Aplicación SPA Catálogo SENATI
/// Implementa arquitectura modular, rutas nombradas y Material Design 3
class CatalogoSenatiApp extends StatelessWidget {
  const CatalogoSenatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo SENATI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        final routeName = settings.name ?? '';

        // Soporte unificado para rutas SPA tanto web (#) como móviles/desktop
        if (routeName == '/' ||
            routeName == '/home' ||
            routeName == '/#/home' ||
            routeName.startsWith('/home')) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const HomeScreen(),
          );
        }

        if (routeName == '/details' ||
            routeName == '/#/details' ||
            routeName.startsWith('/details')) {
          final args = settings.arguments as ComponentItem?;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => DetailsScreen(component: args),
          );
        }

        // Por defecto redirige a HomeScreen
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      },
    );
  }
}
