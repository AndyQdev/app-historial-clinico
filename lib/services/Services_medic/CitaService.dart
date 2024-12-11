import 'package:dio/dio.dart';
import 'package:historial_medico_apk/utils/Endpoints.dart';

class CitaService {
  final Dio _dio = Dio();
  final String baseUrl = Endpoints.baseUrl;

  Future<Map<String, dynamic>> crearCita({
    required String medicoId,
    required String pacienteId,
    required String servicioId,
    required String especialidadId,
  }) async {
    try {
      print(medicoId + pacienteId + servicioId + especialidadId);
      final response = await _dio.post(
        baseUrl + Endpoints.crearCita,
        data: {
          'medicoId': medicoId,
          'pacienteId': pacienteId,
          'servicioId': servicioId,
          'especialidadId': especialidadId,
        },
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        print('Error al crear la cita: ${response.data}');
        throw Exception('Error al crear la cita.');
      }
    } catch (error) {
      print('Error al crear la cita: $error');
      throw Exception('No se pudo crear la cita. Inténtelo de nuevo.');
    }
  }
}
