import 'dart:convert';

String extractErrorMessage(dynamic data) {
  // Valor por defecto
  String message = "Error de conexión";

  if (data == null) return message;

  try {
    Map<String, dynamic>? jsonData;

    // Si data es String, intentar parsear JSON
    if (data is String) {
      final parsed = jsonDecode(data);
      if (parsed is Map) {
        jsonData = Map<String, dynamic>.from(parsed);
      } else {
        // Si no es Map, devolvemos el String tal cual
        return data;
      }
    } 
    // Si ya es Map
    else if (data is Map) {
      jsonData = Map<String, dynamic>.from(data);
    } 
    else {
      return message;
    }

    // Extraer mensaje de manera segura
    if (jsonData != null) {
      final dynamic innerMessage = jsonData["message"];

      if (innerMessage is Map) {
        final inner = Map<String, dynamic>.from(innerMessage);
        message = inner["message"] ?? inner["mensaje"] ?? message;
      } else if (innerMessage is String) {
        message = innerMessage; // 👈 captura "Token no proporcionado"
      }
    }
  } catch (_) {
    // Si ocurre cualquier error al parsear JSON
    if (data is String) message = data;
  }

  return message;
}
