import 'package:flutter/material.dart';
import 'package:historial_medico_apk/utils/routes.model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:historial_medico_apk/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('paciente_nombre') ?? 'Invitado';
    });
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Function() onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          elevation: 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Noticias',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Protect yourself and your family from Covid-19',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundSecondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/perfil.webp'),
                        radius: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Bienvenido ${userName ?? 'Invitado'} 👋',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for poly',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildNewsSection(),
              const SizedBox(height: 20),
              const Text(
                'Que necesitas?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildNavigationButton(
                      context: context,
                      icon: Icons.calendar_today,
                      label: 'Agendar Cita',
                      onPressed: () => Navigator.pushNamed(context, PrivateRoutes.horariosDisponibles),
                    ),
                    _buildNavigationButton(
                      context: context,
                      icon: Icons.medical_services,
                      label: 'Tratamiento',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/tratamientos'),
                    ),
                    _buildNavigationButton(
                      context: context,
                      icon: Icons.local_hospital,
                      label: 'Ambulance',
                      onPressed: () => Navigator.pushNamed(context, '/ambulance'),
                    ),
                    _buildNavigationButton(
                      context: context,
                      icon: Icons.alarm,
                      label: 'Recordatorio',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/recordatorios'),
                    ),
                    _buildNavigationButton(
                      context: context,
                      icon: Icons.warning,
                      label: 'Emergency',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/emergency'),
                    ),
                    _buildNavigationButton(
                      context: context,
                      icon: Icons.science,
                      label: 'Lab Test',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/lab_test'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
