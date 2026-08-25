class HistorialPrecio {
  final int id;
  final int idProducto;
  final String nombreProducto;
  final double precioActual;
  final bool activo;
  final double precioAnterior;
  final double precioNuevo;
  final DateTime fecha;
  final String motivo;

  HistorialPrecio({
    required this.id,
    required this.idProducto,
    required this.nombreProducto,
    required this.precioActual,
    required this.activo,
    required this.precioAnterior,
    required this.precioNuevo,
    required this.fecha,
    required this.motivo,
  });

  /// Variación porcentual respecto al precio anterior.
  /// null cuando el precio anterior es 0 (precio inicial, no hay variación real).
  double? get variacionPorcentaje {
    if (precioAnterior == 0) return null;
    return ((precioNuevo - precioAnterior) / precioAnterior) * 100;
  }

  double get variacionAbsoluta => precioNuevo - precioAnterior;

  /// 'aumento' | 'reduccion' | 'sin_cambio'
  String get tipoVariacion {
    if (precioAnterior == 0) return 'sin_cambio';
    if (precioNuevo > precioAnterior) return 'aumento';
    if (precioNuevo < precioAnterior) return 'reduccion';
    return 'sin_cambio';
  }
}