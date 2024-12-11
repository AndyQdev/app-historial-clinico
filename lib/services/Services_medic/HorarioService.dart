import 'package:dio/dio.dart';
import 'package:historial_medico_apk/utils/Endpoints.dart';

class HorarioService {
  final Dio _dio = Dio();
  final String baseUrl = Endpoints.baseUrl;

  Future<List<Map<String, dynamic>>> fetchHorarios() async {
    try {
      final response = await _dio.get(baseUrl + Endpoints.horarios);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (error) {
      throw Exception('Error fetching schedules: $error');
    }
  }
}
