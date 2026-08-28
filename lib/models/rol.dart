
class Rol {
  final int id; // viene de id_rol
  final String nombre; // viene de nombre_rol
  final String? descripcion;
  final int? nivelAcceso; // viene de nivel_acceso

  Rol({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.nivelAcceso,
  });

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      id: json['id_rol'] is int
          ? json['id_rol']
          : int.tryParse('${json['id_rol']}') ?? 0,
      nombre: json['nombre_rol'] ?? '',
      descripcion: json['descripcion'],
      nivelAcceso: json['nivel_acceso'] is int
          ? json['nivel_acceso']
          : int.tryParse('${json['nivel_acceso']}'),
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre_rol': nombre,
        'descripcion': descripcion,
        'nivel_acceso': nivelAcceso,
      };
}