class Notificacion {
  final int id;
  final String titulo;
  final String tipo; // 'alerta' | 'info' | 'exito' | 'advertencia'
  final String mensaje;
  final DateTime fecha;
  bool leida;

  Notificacion({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.mensaje,
    required this.fecha,
    this.leida = false,
  });
}