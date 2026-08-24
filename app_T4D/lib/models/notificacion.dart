class Notificacion {
  final int id;
  final String titulo;

  // Valores permitidos:
  // 'alerta' | 'info' | 'exito' | 'aviso' | 'advertencia'
  final String tipo;

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

  /// Texto que se muestra en la etiqueta de la notificación.
  String get etiquetaTipo {
    switch (tipo.toLowerCase()) {
      case 'alerta':
        return 'Alerta';

      case 'info':
        return 'Información';

      case 'exito':
        return 'Éxito';

      case 'aviso':
      case 'advertencia':
        return 'Aviso';

      default:
        return tipo;
    }
  }

  /// Tiempo transcurrido desde que se creó la notificación.
  String get tiempoRelativo {
    final diferencia = DateTime.now().difference(fecha);

    if (diferencia.inMinutes < 1) {
      return 'Ahora';
    }

    if (diferencia.inMinutes < 60) {
      return 'Hace ${diferencia.inMinutes} min';
    }

    if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours} h';
    }

    if (diferencia.inDays == 1) {
      return 'Ayer';
    }

    return 'Hace ${diferencia.inDays} días';
  }
}