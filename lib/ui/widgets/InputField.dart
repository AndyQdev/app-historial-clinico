import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final Function(String?) onSaved;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final TextEditingController? controller; // Agregar controlador opcional
  final VoidCallback? onTap; // Agregar onTap opcional

  const InputField({
    Key? key,
    required this.label,
    this.isPassword = false,
    required this.onSaved,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: isPassword,
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      controller: controller,
      readOnly: onTap != null, // Evitar edición directa si es para fecha
      onTap: onTap, // Llamar onTap cuando sea para fecha
    );
  }
}
