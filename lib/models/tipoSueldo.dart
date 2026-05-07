class TipoSueldo {
  final int id;
  final String nombre;
  final String unidadMedida;
  final String descripcion;
  final bool activo;

  TipoSueldo({
    required this.id,
    required this.nombre,
    required this.unidadMedida,
    required this.descripcion,
    required this.activo,
  });

  factory TipoSueldo.fromJson(Map<String, dynamic> json) {
    return TipoSueldo(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      unidadMedida: json['unidadMedida'] as String,
      descripcion: json['descripcion'] as String,
      activo: json['activo'] as bool,
    );
  }
}