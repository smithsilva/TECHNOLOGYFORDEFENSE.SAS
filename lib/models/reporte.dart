class CategoriaDistribucion {
  final String nombre;
  final int cantidad;

  CategoriaDistribucion({required this.nombre, required this.cantidad});
}

class ProductoDestacado {
  final int posicion;
  final String nombre;
  final int stock;
  final double valor;
  final String estado; // 'alto' | 'medio' | 'bajo'

  ProductoDestacado({
    required this.posicion,
    required this.nombre,
    required this.stock,
    required this.valor,
    required this.estado,
  });
}

class ResumenReporte {
  final int totalProductos;
  final double valorTotal;
  final int stockBajo;
  final int movimientosPeriodo;
  final List<CategoriaDistribucion> categorias;
  final List<ProductoDestacado> destacados;

  ResumenReporte({
    required this.totalProductos,
    required this.valorTotal,
    required this.stockBajo,
    required this.movimientosPeriodo,
    required this.categorias,
    required this.destacados,
  });
}

// ============================================================
// A PARTIR DE AQUÍ: clases nuevas agregadas para los reportes
// de Ventas, Clientes, Empleados, Financiero y Productos.
// Nada de lo anterior fue modificado ni eliminado.
// ============================================================

// ─── VENTAS ──────────────────────────────────────────────────
class VentaPorSucursal {
  final String sucursal;
  final int totalVentas;
  final double montoTotal;

  VentaPorSucursal({
    required this.sucursal,
    required this.totalVentas,
    required this.montoTotal,
  });
}

class VentaPorMetodoPago {
  final String metodoPago;
  final int cantidad;
  final double monto;

  VentaPorMetodoPago({
    required this.metodoPago,
    required this.cantidad,
    required this.monto,
  });
}

class ResumenVentas {
  final int totalVentas;
  final double montoTotal;
  final double promedioVenta;
  final int ventasPeriodo;
  final List<VentaPorSucursal> porSucursal;
  final List<VentaPorMetodoPago> porMetodoPago;

  ResumenVentas({
    required this.totalVentas,
    required this.montoTotal,
    required this.promedioVenta,
    required this.ventasPeriodo,
    required this.porSucursal,
    required this.porMetodoPago,
  });
}

// ─── CLIENTES ────────────────────────────────────────────────
class ClienteDestacado {
  final int posicion;
  final String nombre;
  final double totalCompras;
  final int cantidadPedidos;
  final String estado; // 'alto' | 'medio' | 'bajo'

  ClienteDestacado({
    required this.posicion,
    required this.nombre,
    required this.totalCompras,
    required this.cantidadPedidos,
    required this.estado,
  });
}

// ─── EMPLEADOS ───────────────────────────────────────────────
class EmpleadoRendimiento {
  final int posicion;
  final String nombre;
  final int tareasCompletadas;
  final double eficiencia; // porcentaje 0-100
  final String estado; // 'alto' | 'medio' | 'bajo'

  EmpleadoRendimiento({
    required this.posicion,
    required this.nombre,
    required this.tareasCompletadas,
    required this.eficiencia,
    required this.estado,
  });
}

// ─── FINANCIERO ──────────────────────────────────────────────
class BalancePeriodo {
  final double ingresos;
  final double egresos;
  final double balance;
  final double? variacionPorcentaje;

  BalancePeriodo({
    required this.ingresos,
    required this.egresos,
    required this.balance,
    this.variacionPorcentaje,
  });
}

// ─── PRODUCTOS ───────────────────────────────────────────────
class ProductoMasVendido {
  final int posicion;
  final String nombre;
  final int cantidadVendida;
  final double montoTotal;

  ProductoMasVendido({
    required this.posicion,
    required this.nombre,
    required this.cantidadVendida,
    required this.montoTotal,
  });
}