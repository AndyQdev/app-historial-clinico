import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFEA5367); // Rojo suave, adecuado para el tema médico
  static const Color secondary = Color(0xFF4A6572); // Gris oscuro para acentos secundarios
  static const Color background = Colors.white; // Fondo blanco
  static const Color backgroundSecondary = Color(0xFFF0F2F5); // Fondo gris claro para contraste
  static const Color error = Colors.redAccent; // Color de error
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color inputFill = Colors.grey; // Color para los campos de entrada

  static const MaterialColor inputFill2 = MaterialColor(
    0xFFE0E0E0,
    <int, Color>{
      50: Color(0xFFF5F5F5),
      100: Color(0xFFE0E0E0),
      200: Color(0xFFBDBDBD),
      300: Color(0xFF9E9E9E),
      400: Color(0xFF757575),
      500: Color(0xFF616161),
      600: Color(0xFF424242),
      700: Color(0xFF212121),
      800: Color(0xFF121212),
      900: Color(0xFF000000),
    },
  );
}
