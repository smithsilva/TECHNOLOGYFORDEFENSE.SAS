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

  String get inicial => nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
}