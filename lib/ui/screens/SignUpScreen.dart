import 'package:flutter/material.dart';
import 'package:historial_medico_apk/models/createPaciente.dart';
import 'package:historial_medico_apk/services/AuthService.dart';
import 'package:historial_medico_apk/ui/widgets/CustomButton.dart';
import 'package:historial_medico_apk/ui/widgets/InputField.dart';
import 'package:historial_medico_apk/utils/colors.dart';
import 'package:intl/intl.dart'; // Asegúrate de tener un archivo colors.dart

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _direccion = '';  // Campo para la dirección
  String _telefono = '';   // Campo para el teléfono
  String _nombre = ''; 
  String _apellido = ''; 
  String _numeroSeguro = ''; 

  // Estado para la extensión seleccionada
  Map<String, String> _selectedExtension = {'country': 'Bolivia', 'code': '+591', 'flag': '🇧🇴'};
  String _selectedExtensionCode = '+591';
  // Lista de extensiones de país
  final List<Map<String, String>> _extensions = [
    {'country': 'Bo', 'code': '+591', 'flag': '🇧🇴'},
    {'country': 'US', 'code': '+1', 'flag': '🇺🇸'},
    {'country': 'Gb', 'code': '+44', 'flag': '🇬🇧'},
    {'country': 'Es', 'code': '+34', 'flag': '🇪🇸'},
    // Puedes añadir más países aquí
  ];

  final TextEditingController _dateController = TextEditingController();
  String _fechaNacimiento = ''; // Variable para guardar fecha de nacimiento

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fechaNacimiento = DateFormat('yyyy-MM-dd').format(picked);
        _dateController.text = _fechaNacimiento; // Asignar fecha al controlador
      });
    }
  }

  void _createAccount() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<CreatePatient, dynamic> patientData = {
      CreatePatient.email: _email,
      CreatePatient.password: _password,
      CreatePatient.fechaNacimiento: _fechaNacimiento,
      CreatePatient.nombre: _nombre,
      CreatePatient.apellido: _apellido,
      CreatePatient.telefono: _telefono,
      CreatePatient.direccion: _direccion,
      CreatePatient.numeroSeguro: _numeroSeguro,
    };
      final userExists = await AuthService().checkUserExists(_email);
      if (userExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
              'El usuario ya existe',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        await AuthService().register(patientData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario registrado exitosamente'),
          ),
        );
        Navigator.pushNamed(
          context,
          '/verify',
          arguments: {'email': _email},
        );
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'CREAR CUENTA',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Ingrese su información a continuación para continuar. '
                      'Si ya tiene una cuenta, inicie sesión en su lugar.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Campos de entrada reutilizables
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          label: 'Nombre',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su nombre';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _nombre = value!;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InputField(
                          label: 'Apellido',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su apellido';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _apellido = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    label: 'Correo electrónico',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su correo electrónico';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Ingrese un correo válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  // Input de Fecha de Nacimiento
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            labelText: 'Fecha de Nacimiento', // Label que flota cuando hay texto
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.grey.shade600),
                          ),
                          readOnly: true, // Evitar edición directa
                          onTap: () => _selectDate(context), // Abrir selector de fecha
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su fecha de nacimiento';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InputField(
                          label: 'Seguro',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su número de seguro';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _numeroSeguro = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Selector de extensión con bandera y código de país
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedExtensionCode,
                          underline: Container(),
                          items: _extensions.map((extension) {
                            return DropdownMenuItem<String>(
                              value: extension['code'],
                              child: Row(
                                children: [
                                  Text(extension['flag']!),
                                  const SizedBox(width: 6),
                                  Text('${extension['code']} (${extension['country']})'),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedExtensionCode = newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // InputField de Teléfono
                      Expanded(
                        child: InputField(
                          label: 'Teléfono',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su teléfono';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _telefono = '$_selectedExtensionCode$value';
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    label: 'Direccion',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su direccion';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _direccion = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    label: 'Contraseña',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su contraseña';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  const SizedBox(height: 30),
                  // Botón de Crear cuenta
                  CustomButton(
                    text: 'CREAR CUENTA',
                    onPressed: _createAccount,
                  ),
                  const SizedBox(height: 20),
                  // Texto para redirigir a iniciar sesión
                  Center(
                    child: GestureDetector(
                      onTap: _navigateToLogin,
                      child: const Text(
                        'Ya tienes una cuenta? Iniciar sesión',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
