class Trabajador{
  final int id;
  final String nombres;
  final String apellidos;
  final String dni;
  final String? celular;
  final String cargo;
  final String? condicionTrabajo;
  final String? direccion;
  final String? email;
  final String? fechaIngreso;
  final String? fechaNacimiento;
  final int areaId;
  final String areaNombre;
  final int? userId;
  final String? userName;
  final bool activo;

  Trabajador({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.dni,
    this.celular,
    required this.cargo,
    this.condicionTrabajo,
    this.direccion,
    this.email,
    this.fechaIngreso,
    this.fechaNacimiento,
    required this.areaId,
    required this.areaNombre,
    this.userId,
    this.userName,
    required this.activo,
  });

  factory Trabajador.fromJson(Map<String, dynamic> json) {
    return Trabajador(
      id: json['id'] as int,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      dni: json['dni'] as String,
      celular: json['celular'] as String?,
      cargo: json['cargo'] as String,
      condicionTrabajo: json['condicionTrabajo'] as String?,
      direccion: json['direccion'] as String?,
      email: json['emailPersonal'] as String?,
      fechaIngreso: json['fechaIngreso'] as String?,
      fechaNacimiento: json['fechaNacimiento'] as String?,
      areaId: json['areaId'] as int,
      areaNombre: json['areaNombre'] as String,
      userId: json['userId'] as int?,
      userName: json['userName'] as String?,
      activo: json['activo'] as bool,
    );
  }
}