// routes/app_routes.dart

import 'package:flutter/material.dart';
import 'package:historial_medico_apk/ui/screens/auth/LoginScreen.dart';
import 'package:historial_medico_apk/ui/screens/layout/AppLayout.dart';
import 'package:historial_medico_apk/utils/routes.dart';

// Define las rutas públicas que no necesitan AppLayout
final List<String> publicRoutes = ['/', '/signup', '/verify'];

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeConfig = appRoutes.firstWhere(
      (route) => route.path == settings.name,
      orElse: () => RouteConfig(path: '/', builder: (context, _) => LoginScreen()),
    );

    return MaterialPageRoute(
      builder: (context) {
        final args = settings.arguments as Map<String, dynamic>? ?? {};

        // Condición para verificar si la ruta es pública
        if (publicRoutes.contains(settings.name)) {
          // Renderiza la pantalla sin el AppLayout
          return routeConfig.builder!(context, args);
        } else {
          // Envuelve la pantalla en AppLayout para rutas protegidas
          return AppLayout(child: routeConfig.builder!(context, args));
        }
      },
      settings: settings,
    );
  }
}
