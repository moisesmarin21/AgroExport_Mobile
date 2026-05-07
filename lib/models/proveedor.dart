class Proveedor{
  final int id;
  final String responsable;
  final String ruc;
  final String nroCuenta;
  final String razonSocial;
  final String banco;
  final String ggngln;
  final String clp;
  final String estado;

  Proveedor({
    required this.id,
    required this.responsable,
    required this.ruc,
    required this.nroCuenta,
    required this.razonSocial,
    required this.banco,
    required this.ggngln,
    required this.clp,
    required this.estado,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'] as int,
      responsable: json['responsable'] as String,
      ruc: json['ruc'] as String,
      nroCuenta: json['nroCuenta'] as String,
      razonSocial: json['razonSocial'] as String,
      banco: json['banco'] as String,
      ggngln: json['ggngln'] as String,
      clp: json['clp'] as String,
      estado: json['estado'] as String,
    );
  }
}