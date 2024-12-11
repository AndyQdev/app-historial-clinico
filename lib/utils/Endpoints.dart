import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  // static final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  static final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  static final String baseSocket = dotenv.env['API_SOCKET'] ?? 'http://localhost:9092';
  
  
  // Endpoints
  static const String auth = '/auth';
  static const String validarToken = '/auth/check-token-cliente';
  static const String validarCliente = '/auth/check-existe-cliente';
  static const String registrarPaciente = '/auth/register-paciente';
  static const String verifyCode = '/auth/verify-code';
  static const String reenviarCode = '/auth/resend-code';

  static const String productos = '/api/productos';
  static const String reservas = '/api/reservas';
  static const String loginPaciente = '/auth/login-paciente';

  static const String resetPassword = '/api/reset-password';
  static const String recoverPassword = '/api/forgot-password';
  static const String user = '/api/users';
  static const String register = '/auth/register';
  //endopoints de carrito
  static const String carritoCreate = '/api/carrito/crear';
  static const String role = '/api/roles';
  static const String permiso = '/api/permiso';
  static const String branch = '/api/branch';
  static const String category = '/api/categorias';
  static const String login = '/api/login';
  static const String verify = '/api/checkToken';
  static const String logout = '/api/logout';
  static const String store = '/api/store';
  static const String storeComment = '/api/store-comment';
    //Servicios medics
  static const String horarios = '/api/horarios';
  static const String medicos = '/api/medicos';
  static const String especialidades = '/api/especialidades/listar';
  static const String serviciosMedicos = '/api/servicios-medicos';

  //Atencion medica
  static const String crearCita = '/api/citas';

}
