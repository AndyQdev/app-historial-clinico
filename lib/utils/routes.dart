import 'package:flutter/material.dart';
import 'package:historial_medico_apk/ui/screens/SignUpScreen.dart';
import 'package:historial_medico_apk/ui/screens/auth/LoginScreen.dart';
import 'package:historial_medico_apk/ui/screens/auth/VerifyqueCod.dart';
import 'package:historial_medico_apk/ui/screens/dashboard/HomeScreen.dart';
import 'package:historial_medico_apk/ui/screens/services_medics/horarios_disponibles.dart';
import 'package:historial_medico_apk/utils/routes.model.dart';

class RouteConfig {
  final String path;
  final Widget Function(BuildContext context, Map<String, dynamic> args)? builder;
  final List<String> permissions;

  RouteConfig({
    required this.path,
    this.builder,
    this.permissions = const [],
  });
}

final List<RouteConfig> appRoutes = [
  RouteConfig(path: PrivateRoutes.login, builder: (context, args) => LoginScreen()),
  RouteConfig(path: PrivateRoutes.registrar, builder: (context, args) => SignUpScreen()),
  RouteConfig(
    path: PrivateRoutes.verificarCode,
    builder: (context, args) => VerificationScreen(email: args['email']),
  ),
  RouteConfig(path: PrivateRoutes.home, builder: (context, args) => const HomeScreen()),
  RouteConfig(path: PrivateRoutes.horariosDisponibles, builder: (context, args) => const ScheduleScreen()),

];
