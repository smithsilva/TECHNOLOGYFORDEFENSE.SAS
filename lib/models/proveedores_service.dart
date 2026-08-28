class Proveedor {
  final int id;
  final String? nit;
  final String nombre;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? contacto;

  Proveedor({
    required this.id,
    this.nit,
    required this.nombre,
    this.telefono,
    this.email,
    this.direccion,
    this.contacto,
  });

  /// Mapea exactamente las columnas reales de la tabla `proveedores` en Supabase:
  /// id_proveedor, nit, nombre_proveedor, telefono, email, direccion, contacto_proveedor
  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id_proveedor'] is int
          ? json['id_proveedor']
          : int.tryParse(json['id_proveedor']?.toString() ?? '') ?? 0,
      nit: json['nit']?.toString(),
      nombre: json['nombre_proveedor']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      email: json['email']?.toString(),
      direccion: json['direccion']?.toString(),
      contacto: json['contacto_proveedor']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nit': nit,
      'nombre_proveedor': nombre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'contacto_proveedor': contacto,
    };
  }

  Proveedor copyWith({
    int? id,
    String? nit,
    String? nombre,
    String? telefono,
    String? email,
    String? direccion,
    String? contacto,
  }) {
    return Proveedor(
      id: id ?? this.id,
      nit: nit ?? this.nit,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      contacto: contacto ?? this.contacto,
    );
  }
}
