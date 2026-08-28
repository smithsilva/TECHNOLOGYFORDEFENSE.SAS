class UsuarioLista {
  final int id;
  final String nombre;
  final String correo;
  final String rol; // 'admin' | 'contador' | 'gerente' | 'mecanico' | otros
  final bool activo;

  UsuarioLista({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.activo,
  });

  factory UsuarioLista.fromJson(Map<String, dynamic> json) {
    return UsuarioLista(
      id: json['id_usuario'] ?? json['id'],
      nombre: json['username'] ?? json['nombre'] ?? '',
      correo: json['email'] ?? json['correo'] ?? '',
      rol: json['rol'] ?? json['nombre_rol'] ?? json['id_rol']?.toString() ?? '',
      activo: json['activo'] is bool
          ? json['activo']
          : json['activo'] == 1,
    );
  }

  String get inicial => nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
}