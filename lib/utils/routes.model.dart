import 'package:flutter_dotenv/flutter_dotenv.dart';

class PrivateRoutes {
  // static final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  static final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  
  // Rutas privadas
  static const String auth = '/auth';
  static const String home = '/home';
  static const String horariosDisponibles = '/horariosDisponibles';
  static const String verificarCode = '/verify';
  static const String registrar = '/signup';
  static const String login = '/';
}
