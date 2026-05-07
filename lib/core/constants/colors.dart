import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF198754);
  static const secondary = Color(0xFF707070);
  static const background = Color(0xFFF5F7FA);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color.fromRGBO(117, 117, 117, 1);
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
  static const warning = Color.fromARGB(255, 252, 231, 112);

  static Color estadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'ENTREGADO':
        return Colors.green;
      case 'PROGRAMADO':
        return Colors.orange;
      case 'REPROGRAMADO':
        return Colors.amber;
      case 'AGENCIA':
        return Colors.indigo;
      case 'RECOJO':
        return Colors.blueAccent;
      case 'SALIDA ALMACEN':
        return Colors.lightGreenAccent;
      case 'REPARTO':
        return Colors.brown;
      default:
        // NO HABIDO, DENEGADO, ANULADO
        return Colors.red;
    }
  }

  // Método estático para parsear un color desde string hexadecimal "#RRGGBB"
  static Color fromHex(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('0xff$hex'));
  }
}