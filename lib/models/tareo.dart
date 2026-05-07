import 'package:consorcio_app/models/tareoDetalle.dart';

class Tareo{
  final int id;
  final String fecha;
  final int supervisorId;
  final String supervisorNombre;
  final String estado;
  final double totalCosto;
  final int dia;
  final int mes;
  final int anio;
  final List<TareoDetalle> detalles;

  Tareo({
    required this.id,
    required this.fecha,
    required this.supervisorId,
    required this.supervisorNombre,
    required this.estado,
    required this.totalCosto,
    required this.dia,
    required this.mes,
    required this.anio,
    required this.detalles,
  });

  factory Tareo.fromJson(Map<String, dynamic> json) {
    var detallesJson = json['detalles'] as List;
    List<TareoDetalle> detallesList = detallesJson.map((detalle) => TareoDetalle.fromJson(detalle)).toList();

    return Tareo(
      id: json['id'],
      fecha: json['fecha'],
      supervisorId: json['supervisorId'],
      supervisorNombre: json['supervisorNombre'],
      estado: json['estado'],
      totalCosto: (json['totalCosto'] as num).toDouble(),
      dia: json['dia'],
      mes: json['mes'],
      anio: json['anio'],
      detalles: detallesList,
    );
  }
}