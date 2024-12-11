import 'package:dio/dio.dart';
import 'package:historial_medico_apk/utils/Endpoints.dart';

class MedicService {
  final Dio _dio = Dio();
  final String baseUrl = Endpoints.baseUrl;

  Future<List<Map<String, dynamic>>> fetchMedicos() async {
    try {
      final response = await _dio.get(baseUrl + Endpoints.medicos);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load medicos');
      }
    } catch (error) {
      throw Exception('Error fetching medicos: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchEspecialidades() async {
    try {
      final response = await _dio.get(baseUrl + Endpoints.especialidades);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load especialidades');
      }
    } catch (error) {
      throw Exception('Error fetching especialidades: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchServiciosMedicos() async {
    try {
      final response = await _dio.get(baseUrl + Endpoints.serviciosMedicos);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load servicios medicos');
      }
    } catch (error) {
      throw Exception('Error fetching servicios medicos: $error');
    }
  }

  Future<List<String>> fetchEspecialidadesPorServicio(String servicioId) async {
    try {
      print('$baseUrl/api/servicios-medicos/$servicioId/especialidades');
      final response = await _dio.get('$baseUrl/api/servicios-medicos/$servicioId/especialidades');
      if (response.statusCode == 200) {
        return List<String>.from(response.data.map((item) => item['nombre']));
      } else {
        throw Exception('Failed to load especialidades');
      }
    } catch (error) {
      throw Exception('Error fetching especialidades: $error');
    }
  }
}
