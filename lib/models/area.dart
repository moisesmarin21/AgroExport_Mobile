class Area{
  final int id;
  final String nombre;
  final String descripcion;
  final bool activo;

  Area({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.activo,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      activo: json['activo'] as bool,
    );
  }
}