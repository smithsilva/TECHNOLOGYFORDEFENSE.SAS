class CategoriaBlindaje {
  final int id;
  final String nombre;
  final String descripcion;
  final bool activa;
  final int? categoriaPadre;

  CategoriaBlindaje({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.activa,
    this.categoriaPadre,
  });

  /// Código visual calculado a partir del id (la tabla real no tiene
  /// columna "codigo"), ej: id 5 -> "CAT-005". Solo para mostrar en la UI.
  String get codigo => 'CAT-${id.toString().padLeft(3, '0')}';

  /// Mapea exactamente las columnas reales de la tabla `categorias` en Supabase:
  /// id_categoria, nombre_categoria, descripcion, activo, categoria_padre
  factory CategoriaBlindaje.fromJson(Map<String, dynamic> json) {
    return CategoriaBlindaje(
      id: json['id_categoria'] is int
          ? json['id_categoria']
          : int.tryParse(json['id_categoria']?.toString() ?? '') ?? 0,
      nombre: json['nombre_categoria']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      activa: json['activo'] is bool
          ? json['activo'] as bool
          : (json['activo']?.toString() == 'true'),
      categoriaPadre: json['categoria_padre'] == null
          ? null
          : (json['categoria_padre'] is int
              ? json['categoria_padre']
              : int.tryParse(json['categoria_padre'].toString())),
    );
  }

  /// Solo incluye columnas que existen de verdad en la tabla.
  Map<String, dynamic> toJson() {
    return {
      'nombre_categoria': nombre,
      'descripcion': descripcion,
      'activo': activa,
      'categoria_padre': categoriaPadre,
    };
  }

  CategoriaBlindaje copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    bool? activa,
    int? categoriaPadre,
  }) {
    return CategoriaBlindaje(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      activa: activa ?? this.activa,
      categoriaPadre: categoriaPadre ?? this.categoriaPadre,
    );
  }
}