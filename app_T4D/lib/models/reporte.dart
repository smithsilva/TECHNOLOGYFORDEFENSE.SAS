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