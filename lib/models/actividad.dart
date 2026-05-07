class Actividad {
  final int id;
  final String nombre;
  final String descripcion;
  final int areaId;
  final String areaNombre;
  final bool activo;

  Actividad({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.areaId,
    required this.areaNombre,
    required this.activo,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      areaId: json['areaId'] as int,
      areaNombre: json['areaNombre'] as String,
      activo: json['activo'] as bool,
    );
  }
}