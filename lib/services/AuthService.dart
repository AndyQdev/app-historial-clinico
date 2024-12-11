import 'package:dio/dio.dart';
import 'package:historial_medico_apk/models/createPaciente.dart';
import 'package:historial_medico_apk/utils/Endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = Endpoints.baseUrl;
  final String _tokenKey = 'authToken';
  // Función para iniciar sesión
  Future<String?> login(String email, String password) async {
  try {
    print(email);
    print(password);
    print(baseUrl + Endpoints.loginPaciente);
    final response = await _dio.post(
      baseUrl + Endpoints.loginPaciente,  // Asegúrate de usar el endpoint correcto
      data: {
        'username': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      final token = response.data['token'];
      final paciente = response.data['paciente'];
      //Conectar al servicio de notificaciones
      // NotificationService().connect(paciente['id']);
      // Guardar el token y la información del cliente en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString('paciente_id', paciente['id']);
      await prefs.setString('paciente_nombre', paciente['nombre']);
      await prefs.setString('paciente_apellido', paciente['apellido']);
      await prefs.setString('paciente_email', paciente['email']);
      await prefs.setString('paciente_telefono', paciente['telefono']);
      await prefs.setString('paciente_direccion', paciente['direccion']);
      await prefs.setString('paciente_Seguro', paciente['numeroSeguro']);
      await prefs.setString('paciente_dateNac', paciente['fechaNacimiento']);


      return token;
    } else {
      return null;
    }
  } catch (error) {
    // throw Exception('Error al iniciar sesión: $error');
  }
}

  // Función para cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove('cliente_id');
    await prefs.remove('cliente_nombre');
    await prefs.remove('cliente_email');
    await prefs.remove('cliente_telefono');
    await prefs.remove('cliente_direccion');

  }

  // Función para obtener el token almacenado
  // Método para obtener el token desde SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey); // Devuelve el token guardado
  }

   // Verificar si el token es válido
  Future<bool> isAuthenticated() async {
    String? token = await getToken(); // Obtener el token almacenado
    print('Token: $token');
    if (token == null) {
      return false; // No hay token almacenado
    }

    try {
      final response = await _dio.get(
        baseUrl + Endpoints.validarToken, // Cambia por el endpoint correcto
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('este es la autentificacion $response.data');
      // Si la respuesta es exitosa, el token es válido
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false; // Ocurrió un error (token no válido o expirado)
    }
  }
   // Verificar si el usuario ya existe
  Future<bool> checkUserExists(String email) async {
    try {
      final response = await _dio.get(baseUrl +  Endpoints.validarCliente , queryParameters: {
        'email': email,
      });

      // Si el código de respuesta es 200, el usuario existe
      return response.statusCode == 200;
    } catch (error) {
      // Si hay un error, asumimos que el usuario no existe
      return false;
    }
  }
  // Método para verificar el código de autenticación
  Future<bool> verifyCode(String email, String code) async {
    print(email);
    print(code);
    try {
      final response = await _dio.post(
        '$baseUrl${Endpoints.verifyCode}', // URL de tu endpoint de verificación
        data: {
          'email': email,
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        // Suponiendo que el backend responde con éxito cuando el código es correcto
        return true;
      } else {
        throw Exception('Error en la verificación del código');
      }
    } catch (error) {
      print('Error en la verificación: $error');
      return false; // Retorna false si ocurre algún error
    }
  }
      

    // Registrar nuevo usuario usando un mapa con el enum de campos
  Future<void> register(Map<CreatePatient, dynamic> patientData) async {
    try {
      // Mapea el enum al formato que espera el backend
      final data = {
        'email': patientData[CreatePatient.email],
        'password': patientData[CreatePatient.password],
        'nombre': patientData[CreatePatient.nombre],
        'apellido': patientData[CreatePatient.apellido],
        'telefono': patientData[CreatePatient.telefono],
        'direccion': patientData[CreatePatient.direccion],
        'numeroSeguro': patientData[CreatePatient.numeroSeguro],
        'fechaNacimiento': patientData[CreatePatient.fechaNacimiento],
        'isActive': false,
      };
      print(patientData);
      print('$baseUrl${Endpoints.registrarPaciente}');
      final response = await _dio.post('$baseUrl${Endpoints.registrarPaciente}', data: data);
      if (response.statusCode == 200) {
        print('Usuario registrado exitosamente');
      } else {
        throw Exception('Error al registrar el usuario');
      }
    } catch (error) {
      throw Exception('Error al registrar: $error');
    }
  }
  // Método para enviar el código de verificación
  Future<void> sendVerificationCode(String email) async {
    print(email);
    print(baseUrl + Endpoints.reenviarCode);
    try {
      final response = await _dio.post(
        baseUrl + Endpoints.reenviarCode, // Reemplaza con el endpoint correcto de tu API
        data: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        print('Código de verificación enviado exitosamente.');
      } else {
        throw Exception('Error al enviar el código de verificación.');
      }
    } catch (error) {
      print('Error al enviar el código de verificación: $error');
      throw Exception('No se pudo enviar el código de verificación. Inténtelo de nuevo.');
    }
  }
  Future<String?> getPacienteId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('paciente_id');
  }
}
