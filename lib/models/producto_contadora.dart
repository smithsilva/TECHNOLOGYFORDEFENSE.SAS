class ProductoContadora {
  final int id;
  final String? codigoBarras;
  final String nombre;
  final String? descripcion;
  final String categoria;
  final String? nombreProveedor;
  final String? nitProveedor;
  final String? usuario;
  final String? rolUsuario;
  final String? unidadMedida;
  final double? precio;
  final int stockActual;
  final int stockMinimo;
  final bool activo;
  final String? imagen;

  ProductoContadora({
    required this.id,
    this.codigoBarras,
    required this.nombre,
    this.descripcion,
    required this.categoria,
    this.nombreProveedor,
    this.nitProveedor,
    this.usuario,
    this.rolUsuario,
    this.unidadMedida,
    this.precio,
    required this.stockActual,
    this.stockMinimo = 10,
    this.activo = true,
    this.imagen,
  });

  /// 'alto' | 'medio' | 'bajo' — misma regla que la versión web.
  String get estado {
    if (stockActual > stockMinimo * 1.5) return 'alto';
    if (stockActual > stockMinimo) return 'medio';
    return 'bajo';
  }
}