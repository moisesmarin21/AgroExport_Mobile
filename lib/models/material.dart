class MaterialAlmacen {
  final int id;
  final String nombre;
  final String descripcion;
  final int areaId;
  final String areaNombre;
  final String unidadMedida;
  final double stock;
  final bool activo;

  MaterialAlmacen({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.areaId,
    required this.areaNombre,
    required this.unidadMedida,
    required this.stock,
    required this.activo,
  });

  factory MaterialAlmacen.fromJson(Map<String, dynamic> json) {
    return MaterialAlmacen(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      areaId: json['areaId'] as int,
      areaNombre: json['areaNombre'] as String,
      unidadMedida: json['unidadMedida'] as String,
      stock: json['stock'] as double,
      activo: json['activo'] as bool,
    );
  }
}