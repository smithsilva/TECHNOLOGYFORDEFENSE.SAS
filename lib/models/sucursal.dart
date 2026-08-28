class Sucursal {
  final int id;
  final String nombre;
  final String? direccion;
  final String? ciudad;
  final String? telefono;
  final String? horarioApertura;
  final String? horarioCierre;
  final bool activo;

  Sucursal({
    required this.id,
    required this.nombre,
    this.direccion,
    this.ciudad,
    this.telefono,
    this.horarioApertura,
    this.horarioCierre,
    this.activo = true,
  });

  /// Mapea las columnas reales de la tabla `sucursales`:
  /// id_sucursal, nombre_sucursal, direccion, ciudad, telefono,
  /// horario_apertura, horario_cierre, activo
  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id_sucursal'] is int
          ? json['id_sucursal']
          : int.tryParse(json['id_sucursal']?.toString() ?? '') ?? 0,
      nombre: json['nombre_sucursal']?.toString() ?? '',
      direccion: json['direccion']?.toString(),
      ciudad: json['ciudad']?.toString(),
      telefono: json['telefono']?.toString(),
      horarioApertura: json['horario_apertura']?.toString(),
      horarioCierre: json['horario_cierre']?.toString(),
      activo: json['activo'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_sucursal': nombre,
      'direccion': direccion,
      'ciudad': ciudad,
      'telefono': telefono,
      'horario_apertura': horarioApertura,
      'horario_cierre': horarioCierre,
      'activo': activo,
    };
  }
}