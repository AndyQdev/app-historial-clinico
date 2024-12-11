import 'dart:math';

import 'package:flutter/material.dart';
import 'package:historial_medico_apk/services/Services_medic/CitaService.dart';
import 'package:historial_medico_apk/ui/screens/layout/AppLayout.dart';
import 'package:historial_medico_apk/utils/colors.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleDetailScreen extends StatelessWidget {
  
  final Map<String, dynamic> schedule;
  // final CitaService citaService = CitaService();
  final CitaService citaService = CitaService();
  ScheduleDetailScreen({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: AppLayout(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Encabezado
                const Center(
                  child: Text(
                    'Detalles de la cita',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Mini perfil del doctor
                _buildDoctorProfileCard(
                  doctorName: schedule['doctor'] ?? 'No especificado',
                  rating: schedule['rating'] ?? 'No disponible',
                  icon: Icons.person_outline,
                  backgroundColor: Colors.white, 
                ),

                // Fecha y hora
                _buildDetailCard(
                  title: 'Fecha y Hora',
                  content: '${schedule['dia']}, ${schedule['horaInicio']} - ${schedule['horaFin']}',
                  icon: Icons.calendar_today_outlined,
                  backgroundColor: Colors.white,
                ),

                // Servicio médico, especialidad, descripción y precio en una sola tarjeta
                _buildMedicalServiceCard(
                  serviceName: schedule['service'] ?? 'No especificado',
                  specialtyName: schedule['specialty'] ?? 'No especificado',
                  serviceDescription: schedule['descripcionServicio'] ?? 'Sin descripción',
                  servicePrice: '\$${schedule['precioServicio'] ?? 'No disponible'}',
                  backgroundColor: Colors.white,
                ),

                const SizedBox(height: 32),

                // Botón Agendar Cita
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _scheduleAppointment(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Agendar Cita',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorProfileCard({
    required String doctorName,
    required dynamic rating,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: backgroundColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.15),
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doctor $doctorName',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[600], size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '$rating',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String content,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: backgroundColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.15),
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalServiceCard({
    required String serviceName,
    required String specialtyName,
    required String serviceDescription,
    required String servicePrice,
    required Color backgroundColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: backgroundColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.15),
              ),
              child: const Icon(Icons.local_hospital_outlined, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Servicio Médico',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    serviceName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Especialidad: $specialtyName',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    serviceDescription,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Precio: $servicePrice',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scheduleAppointment(BuildContext context) async {
  try {
    // Llamar al servicio para crear la cita
    final prefs = await SharedPreferences.getInstance();
    final pacienteId = prefs.getString('paciente_id');
    final citaCreada = await citaService.crearCita(
      medicoId: schedule['medicoId'],
      pacienteId: pacienteId ?? '',
      servicioId: schedule['serviceId'],
      especialidadId: schedule['specialtyId'],
    );
    // Extraer el código de cita y demás información necesaria
    final codigoCita = citaCreada['codigoCita'];

    // Mostrar el diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: EdgeInsets.zero,
          title: Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  'Cita Agendada',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Nro Ficha: $codigoCita',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Día: ${schedule['dia']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Hora: ${schedule['horaInicio']} - ${schedule['horaFin']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.local_hospital, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Servicio: ${schedule['service']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.attach_money, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Precio: \$${schedule['precioServicio']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            // Botón para compartir la información de la cita
            TextButton(
              onPressed: () {
                // Implementar lógica para compartir
                final mensaje = 'Cita agendada exitosamente.\n'
                    'Código: $codigoCita\n'
                    'Día: ${schedule['dia']}\n'
                    'Hora: ${schedule['horaInicio']} - ${schedule['horaFin']}\n'
                    'Servicio: ${schedule['service']}\n'
                    'Precio: \$${schedule['precioServicio']}';

                Share.share(mensaje); // Requiere el paquete 'share'
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              ),
              child: const Text(
                'Compartir',
                style: TextStyle(fontSize: 16, color: AppColors.primary),
              ),
            ),
            // Botón para continuar al home
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.of(context).pushReplacementNamed('/home'); // Navega al home
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(fontSize: 16, color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  } catch (e) {
    // Mostrar error en caso de fallo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al agendar la cita: $e'),
      ),
    );
  }
}

}
