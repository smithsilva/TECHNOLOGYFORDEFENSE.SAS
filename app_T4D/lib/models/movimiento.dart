class Movimiento {
  final int id;
  final DateTime fecha;
  final String tipo; // 'entrada' | 'salida'
  final String producto;
  final String usuario;
  final String motivo;
  final int cantidad; // positivo en entradas, negativo en salidas

  Movimiento({
    required this.id,
    required this.fecha,
    required this.tipo,
    required this.producto,
    required this.usuario,
    required this.motivo,
    required this.cantidad,
  });
}