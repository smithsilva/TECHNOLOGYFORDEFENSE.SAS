/// Modelo de un producto de inventario.
/// Basado en la tabla `productos` (y su relación con `proveedores`,
/// `categorias` y `sucursales`) que ya usas en la versión web con Supabase.
class Producto {
  final int idProducto;
  final String nombreProducto;
  final String? descripcion;
  final String? codigoBarras;
  final double? precioActual;
  final int stockActual;
  final int stockMinimo;
  final String? unidadMedida;
  final String? imagen;

  final int? idCategoria;
  final String? nombreCategoria;

  final int? idProveedor;
  final String? nombreProveedor;
  final String? nitProveedor;

  final int? idSucursal;
  final String? nombreSucursal;
  final String? ciudadSucursal;

  final String? blindaje; // ej: "Blindaje Nivel 1" (se ve en las tarjetas)

  Producto({
    required this.idProducto,
    required this.nombreProducto,
    this.descripcion,
    this.codigoBarras,
    this.precioActual,
    this.stockActual = 0,
    this.stockMinimo = 10,
    this.unidadMedida,
    this.imagen,
    this.idCategoria,
    this.nombreCategoria,
    this.idProveedor,
    this.nombreProveedor,
    this.nitProveedor,
    this.idSucursal,
    this.nombreSucursal,
    this.ciudadSucursal,
    this.blindaje,
  });

  /// Igual que `calcularEstado` en el JSX: alto / medio / bajo
  String get estado {
    final minimo = stockMinimo == 0 ? 10 : stockMinimo;
    if (stockActual > minimo * 1.5) return 'alto';
    if (stockActual > minimo) return 'medio';
    return 'bajo';
  }

  factory Producto.fromJson(Map<String, dynamic> json) {
    final proveedor = json['proveedores'] as Map<String, dynamic>?;
    final categoria = json['categorias'] as Map<String, dynamic>?;
    final sucursal = json['sucursales'] as Map<String, dynamic>?;

    return Producto(
      idProducto: json['id_producto'] as int,
      nombreProducto: json['nombre_producto']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      codigoBarras: json['codigo_barras']?.toString(),
      precioActual: json['precio_actual'] == null
          ? null
          : double.tryParse(json['precio_actual'].toString()),
      stockActual: int.tryParse(json['stock_actual']?.toString() ?? '') ?? 0,
      stockMinimo: int.tryParse(json['stock_minimo']?.toString() ?? '') ?? 10,
      unidadMedida: json['unidad_medida']?.toString(),
      imagen: json['imagen']?.toString(),
      idCategoria: json['id_categoria'] as int?,
      nombreCategoria: categoria?['nombre_categoria']?.toString(),
      idProveedor: json['id_proveedor'] as int?,
      nombreProveedor: proveedor?['nombre_proveedor']?.toString(),
      nitProveedor: proveedor?['nit']?.toString(),
      idSucursal: json['id_sucursal'] as int?,
      nombreSucursal: sucursal?['nombre_sucursal']?.toString(),
      ciudadSucursal: sucursal?['ciudad']?.toString(),
      blindaje: json['blindaje']?.toString(),
    );
  }
}