import 'package:flutter/material.dart';
import 'package:historial_medico_apk/services/Services_medic/HorarioService.dart';
import 'package:historial_medico_apk/services/Services_medic/medicService.dart';
import 'package:historial_medico_apk/ui/screens/services_medics/ScheduleDetailScreen.dart';
import 'package:historial_medico_apk/utils/colors.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _searchController = TextEditingController();
  final HorarioService _horarioService = HorarioService();
  final MedicService _dataService = MedicService();
  String _selectedService = 'Todos';
  String _selectedSpecialty = 'Todos';
  String _selectedServiceName = 'Todos';
  String _selectedDay = 'Todos';
  List<Map<String, dynamic>> schedules = [];
  List<Map<String, String>> services = [{'id': 'Todos', 'nombre': 'Todos'}];
  List<String> specialties = ['Todos'];
  bool isLoading = true;
  List<Map<String, dynamic>> filteredSchedules = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    print(schedules);
    print('Hola');
  }
  Future<void> _loadHorarios() async {
    try {
      final fetchedSchedules = await _horarioService.fetchHorarios();
      setState(() {
        schedules = fetchedSchedules;
        filteredSchedules = schedules; // Asigna aquí filteredSchedules después de cargar schedules
        isLoading = false;
      });
      print('Horarios cargados: $filteredSchedules');
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error loading schedules: $error');
    }
  }
  Future<void> _loadData() async {
    try {
      final fetchedServices = await _dataService.fetchServiciosMedicos();
      setState(() {
        services =services = [
          {'id': 'Todos', 'nombre': 'Todos'},
          ...fetchedServices.map((service) => {
            'id': service['id'] as String,
            'nombre': service['nombre'] as String
          })
        ]; 
      });
      _loadHorarios();
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  Future<void> _loadEspecialidades(String servicioSeleccionado) async {
    try {
      final fetchedEspecialidades = await _dataService.fetchEspecialidadesPorServicio(servicioSeleccionado);
      setState(() {
        specialties = ['Todos', ...fetchedEspecialidades];
        _selectedSpecialty = 'Todos'; // Restablecer especialidad
      });
      print(specialties);
    } catch (error) {
      print('Error loading especialidades: $error');
    }
  }
  // final List<String> services = ['Todos', 'Consulta General', 'Pediatría', 'Cardiología'];
  // final Map<String, List<String>> specialties = {
  //   'Todos': ['Todos'],
  //   'Consulta General': ['Consulta Preventiva', 'Consulta Diagnóstica'],
  //   'Pediatría': ['Neonatología', 'Cuidados Intensivos'],
  //   'Cardiología': ['Cardiología Preventiva', 'Cardiología Diagnóstica'],
  // };

  final List<String> daysOfWeekAbbr = ['Todos', 'L', 'M', 'Mi', 'J', 'V', 'S', 'D'];

  // Mapeo de abreviaturas a nombres completos de días
  final Map<String, String> dayMapping = {
    'Todos': 'Todos',
    'L': 'Lunes',
    'M': 'Martes',
    'Mi': 'Miercoles',
    'J': 'Jueves',
    'V': 'Viernes',
    'S': 'Sábado',
    'D': 'Domingo',
  };
  // Ejemplo de horarios, estos deben venir del backend
  // final List<Map<String, dynamic>> schedules = [
  //   {'id': '1', 'dia': 'Lunes', 'horaInicio': '09:00', 'horaFin': '12:00', 'doctor': 'Dr. Smith', 'service': 'Consulta General', 'specialty': 'Consulta Preventiva', 'rating': 4.7},
  //   {'id': '2', 'dia': 'Martes', 'horaInicio': '13:00', 'horaFin': '16:00', 'doctor': 'Dr. Taylor', 'service': 'Cardiología', 'specialty': 'Cardiología Diagnóstica', 'rating': 5.0},
  //   {'id': '3', 'dia': 'Miércoles', 'horaInicio': '10:00', 'horaFin': '12:00', 'doctor': 'Dr. Johnson', 'service': 'Pediatría', 'specialty': 'Neonatología', 'rating': 4.3},
  // ];




  void _filterSchedules() {
    setState(() {
      print(_selectedService);
      print(_selectedSpecialty);
      filteredSchedules = schedules.where((schedule) {
        final matchesDay = _selectedDay == 'Todos' || schedule['dia'] == dayMapping[_selectedDay];
        final matchesService = _selectedService == 'Todos' || schedule['service'] == _selectedServiceName;
        final matchesSpecialty = _selectedSpecialty == 'Todos' || schedule['specialty'] == _selectedSpecialty;
        final matchesSearch = schedule['doctor']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());

        return matchesDay && matchesService && matchesSpecialty && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horarios Disponibles',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 1),

            // Buscador de médicos
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por médico...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => _filterSchedules(),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedService,
              decoration: InputDecoration(
                labelText: 'Servicio Médico',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              items: services.map((service) {
                return DropdownMenuItem<String>(
                  value: service['id'], // Utiliza el ID como valor
                  child: Text(service['nombre']!), // Muestra el nombre en el dropdown
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedService = newValue!;
                  _selectedServiceName = services
                  .firstWhere((service) => service['id'] == _selectedService)['nombre']!;
                  _loadEspecialidades(_selectedService);  // Restablece especialidad cuando se cambia el servicio
                  _filterSchedules(); // Restablece especialidad cuando se cambia el servicio
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedSpecialty,
              decoration: InputDecoration(
                labelText: 'Especialidad',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              items: specialties.map((String specialty) {
                return DropdownMenuItem<String>(
                  value: specialty,
                  child: Text(specialty),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSpecialty = newValue!;
                  _filterSchedules();
                });
              },
            ),
            const Text(
              'Día de la Semana',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: daysOfWeekAbbr.map((day) {
                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: day,
                        groupValue: _selectedDay,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedDay = value!;
                            _filterSchedules(); // Llama a la función de filtrado al seleccionar un día
                          });
                        },
                      ),
                      Text(day),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // Lista de horarios disponibles
            Expanded(
              child: ListView.builder(
                itemCount: filteredSchedules.length,
                itemBuilder: (context, index) {
                  final schedule = filteredSchedules[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/perfil.webp'), // Imagen de perfil
                      ),
                      title: Text('${schedule['doctor']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${schedule['dia']}'),
                          Text('${schedule['horaInicio']} - ${schedule['horaFin']}'),
                          Text('Especialidad: ${schedule['specialty']}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text('${schedule['rating']}'),
                        ],
                      ),
                      onTap: () {
                      print(schedule);  
                      // Navegar a la pantalla de detalles del horario
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduleDetailScreen(
                            schedule: schedule,
                          ),
                        ),
                      );
                    },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
