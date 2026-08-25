class Movimiento {
  final int id;
  final DateTime fecha;
  final String tipo; // 'entrada' | 'salida'
  final String producto;
  final String usuario;
  final String motivo;
  final int cantidad; // ya viene con signo (+/-)

  Movimiento({
    required this.id,
    required this.fecha,
    required this.tipo,
    required this.producto,
    required this.usuario,
    required this.motivo,
    required this.cantidad,
  });

  factory Movimiento.fromJson(Map<String, dynamic> json) {
    final productoJson = json['productos'] as Map<String, dynamic>?;
    final usuarioJson = json['usuarios'] as Map<String, dynamic>?;

    final tipo = json['tipo_movimiento'] ?? '';
    final cantidadRaw = json['cantidad'] is int
        ? json['cantidad'] as int
        : int.tryParse(json['cantidad'].toString()) ?? 0;
    final cantidadFirmada =
        tipo == 'salida' ? -cantidadRaw.abs() : cantidadRaw.abs();

    return Movimiento(
      id: json['id_movimiento'],
      fecha: json['fecha_movimiento'] != null
          ? DateTime.tryParse(json['fecha_movimiento']) ?? DateTime.now()
          : DateTime.now(),
      tipo: tipo,
      producto: productoJson?['nombre_producto'] ?? '—',
      usuario: usuarioJson?['username'] ?? '—',
      motivo: json['observacion'] ?? '',
      cantidad: cantidadFirmada,
    );
  }
}