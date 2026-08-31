/// Modelo de una notificación, basado en la tabla `notificaciones` real:
/// id_notificacion | titulo | descripcion | fecha | leido | rol_destino | id_usuario | id_asignacion
class Notificacion {
  final int id;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  bool leido;
  final String rolDestino;
  final int? idUsuario;
  final int? idAsignacion;

  Notificacion({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.leido,
    required this.rolDestino,
    this.idUsuario,
    this.idAsignacion,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id_notificacion'] as int,
      titulo: json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      fecha: DateTime.parse(json['fecha'] as String),
      // El backend puede devolver el booleano como bool nativo (Postgres)
      // o como 0/1 (MySQL); cubrimos ambos casos.
      leido: json['leido'] is bool
          ? json['leido'] as bool
          : json['leido'].toString() == 'true' || json['leido'].toString() == '1',
      rolDestino: json['rol_destino']?.toString() ?? '',
      idUsuario: json['id_usuario'] as int?,
      idAsignacion: json['id_asignacion'] as int?,
    );
  }

  /// Deriva un "tipo" visual (alerta/exito/advertencia/info) a partir del
  /// título, ya que la tabla real no tiene columna `tipo`. Ajusta las
  /// palabras clave si tu backend usa otros prefijos de título.
  String get tipo {
    final t = titulo.toLowerCase();
    if (t.contains('stock bajo') || t.contains('alerta')) return 'alerta';
    if (t.contains('cambio de precio') || t.contains('precio')) return 'advertencia';
    if (t.contains('movimiento')) return 'exito';
    return 'info'; // por ejemplo "Nueva asignación"
  }
}