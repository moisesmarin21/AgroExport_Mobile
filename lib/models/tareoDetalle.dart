class TareoDetalle {
  final int id;
  final int tareoId;
  final int trabajadorId;
  final String trabajadorNombre;
  final int areaId;
  final String areaNombre;
  final int actividadId;
  final String actividadNombre;
  final int tipoSueldoId;
  final String tipoSueldoNombre;
  final String horaInicio;
  final String horaFin;
  final String horaInicioRefrigerio;
  final String horaFinRefrigerio;
  final double cantidadHoras;
  final double rendimientoDestajo;
  final double tarifa;
  final double costoPasaje;
  final double costoAlmuerzo;
  final double costoTotal;
  final String observacion;

  TareoDetalle({
    required this.id,
    required this.tareoId,
    required this.trabajadorId,
    required this.trabajadorNombre,
    required this.areaId,
    required this.areaNombre,
    required this.actividadId,
    required this.actividadNombre,
    required this.tipoSueldoId,
    required this.tipoSueldoNombre,
    required this.horaInicio,
    required this.horaFin,
    required this.horaInicioRefrigerio,
    required this.horaFinRefrigerio,
    required this.cantidadHoras,
    required this.rendimientoDestajo,
    required this.tarifa,
    required this.costoPasaje,
    required this.costoAlmuerzo,
    required this.costoTotal,
    required this.observacion,
  });

  factory TareoDetalle.fromJson(Map<String, dynamic> json) {
    return TareoDetalle(
      id: json['id'],
      tareoId: json['tareoId'],
      trabajadorId: json['trabajadorId'],
      trabajadorNombre: json['trabajadorNombre'],
      areaId: json['areaId'],
      areaNombre: json['areaNombre'],
      actividadId: json['actividadId'],
      actividadNombre: json['actividadNombre'],
      tipoSueldoId: json['tipoSueldoId'],
      tipoSueldoNombre: json['tipoSueldoNombre'],
      horaInicio: json['horaInicio'],
      horaFin: json['horaFin'],
      horaInicioRefrigerio: json['horaInicioRefrigerio'],
      horaFinRefrigerio: json['horaFinRefrigerio'],
      cantidadHoras: (json['cantidadHoras'] as num).toDouble(),
      rendimientoDestajo: (json['rendimientoDestajo'] as num).toDouble(),
      tarifa: (json['tarifa'] as num).toDouble(),
      costoPasaje: (json['costoPasaje'] as num).toDouble(),
      costoAlmuerzo: (json['costoAlmuerzo'] as num).toDouble(),
      costoTotal: (json['costoTotal'] as num).toDouble(),
      observacion: json['observaciones'] ?? '',
    );
  }
}