import 'package:flutter/material.dart';
import '../../models/reporte.dart';
// import '../services/reportes_service.dart'; // ← lo conectas cuando pases de mock a datos reales

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const navy = Color(0xFF13202E);
  static const azul = Color(0xFF3B82F6);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const rojo = Color(0xFFC0392B);
  static const rojoFondo = Color(0xFFFBE2DF);
  static const textoMuted = Color(0xFF6B7280);
}

class ReportesScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const ReportesScreen({super.key, this.usuario});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  bool _cargando = false;
  ResumenReporte? _resumen;

  @override
  void initState() {
    super.initState();
    _cargarReporte();
  }

  /// Por ahora carga datos de ejemplo (mock) para la parte visual.
  /// Cuando conectes el backend, reemplaza el contenido de este método
  /// por una llamada a tu ReportesService, por ejemplo:
  ///
  /// final data = await ReportesService().obtenerResumen();
  /// setState(() => _resumen = data);
  Future<void> _cargarReporte() async {
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _resumen = ResumenReporte(
        totalProductos: 13,
        valorTotal: 3280000,
        stockBajo: 3,
        movimientosPeriodo: 16,
        categorias: [
          CategoriaDistribucion(nombre: 'Blindaje Nivel 1', cantidad: 3),
          CategoriaDistribucion(nombre: 'Blindaje Nivel 2', cantidad: 6),
          CategoriaDistribucion(nombre: 'Blindaje Nivel 3', cantidad: 1),
          CategoriaDistribucion(nombre: 'Blindaje Nivel 4', cantidad: 1),
          CategoriaDistribucion(nombre: 'Blindaje Nivel 5', cantidad: 2),
        ],
        destacados: [
          ProductoDestacado(
            posicion: 1,
            nombre: 'Kit de Embrague Toyota',
            stock: 780000,
            valor: 780000,
            estado: 'alto',
          ),
          ProductoDestacado(
            posicion: 2,
            nombre: 'Neumático Todo Terreno 265/70R17',
            stock: 16,
            valor: 15200000,
            estado: 'alto',
          ),
          ProductoDestacado(
            posicion: 3,
            nombre: 'Batería 12V 900A',
            stock: 10,
            valor: 5800000,
            estado: 'bajo',
          ),
          ProductoDestacado(
            posicion: 4,
            nombre: 'Amortiguador Delantero Reforzado',
            stock: 5,
            valor: 1600000,
            estado: 'bajo',
          ),
        ],
      );
      _cargando = false;
    });
  }

  void _mostrarProximamente(String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$accion: próximamente')),
    );
  }

  String _formatoMiles(num numero) {
    final texto = numero.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (var i = 0; i < texto.length; i++) {
      final posDesdeFinal = texto.length - i;
      buffer.write(texto[i]);
      if (posDesdeFinal > 1 && posDesdeFinal % 3 == 1) buffer.write('.');
    }
    return buffer.toString();
  }

  /// Convierte un número grande a formato compacto tipo "$3.28M"
  String _formatoCompacto(double numero) {
    if (numero >= 1000000) {
      return '\$${(numero / 1000000).toStringAsFixed(2)}M';
    } else if (numero >= 1000) {
      return '\$${(numero / 1000).toStringAsFixed(1)}K';
    }
    return '\$${numero.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final r = _resumen;
    final maxCantidad = r == null || r.categorias.isEmpty
        ? 1
        : r.categorias.map((c) => c.cantidad).reduce((a, b) => a > b ? a : b);

    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarReporte,
        child: _cargando || r == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Encabezado / título de la sección
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.doradoClaro),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reportes',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Resumen y estadísticas del inventario',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tarjetas de estadísticas (oscuras)
                  Row(
                    children: [
                      Expanded(
                        child: _tarjetaEstadistica(
                          'Total Productos',
                          '${r.totalProductos}',
                          'en inventario',
                          AppColors.dorado,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _tarjetaEstadistica(
                          'Valor Total',
                          _formatoCompacto(r.valorTotal),
                          'en stock',
                          AppColors.azul,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _tarjetaEstadistica(
                          'Stock Bajo',
                          '${r.stockBajo}',
                          'productos críticos',
                          AppColors.rojo,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _tarjetaEstadistica(
                          'Movimientos',
                          '${r.movimientosPeriodo}',
                          'en el periodo',
                          AppColors.verde,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Distribución por categoría
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.doradoClaro),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distribución por Categoría',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 14),
                        ...r.categorias.map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        c.nombre,
                                        style: const TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      '${c.cantidad} prod.',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.doradoOscuro,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: LinearProgressIndicator(
                                    value: c.cantidad / maxCantidad,
                                    minHeight: 8,
                                    backgroundColor: AppColors.fondo,
                                    valueColor:
                                        const AlwaysStoppedAnimation(AppColors.dorado),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Productos destacados
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.doradoClaro),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Productos Destacados',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        ...r.destacados.map((p) => _filaDestacado(p)),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _tarjetaEstadistica(String titulo, String valor, String subtitulo, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
          const SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            subtitulo,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _filaDestacado(ProductoDestacado p) {
    final esAlto = p.estado == 'alto';
    final colorEstado = esAlto ? AppColors.verde : AppColors.rojo;
    final fondoEstado = esAlto ? AppColors.verdeFondo : AppColors.rojoFondo;
    final textoEstado = esAlto ? 'Alto' : 'Bajo';

    return InkWell(
      onTap: () => _mostrarProximamente('Ver "${p.nombre}"'),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.doradoClaro.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${p.posicion}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.doradoOscuro,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.nombre,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Stock: ${_formatoMiles(p.stock)} · \$${_formatoMiles(p.valor)}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textoMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: fondoEstado,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                textoEstado,
                style: TextStyle(color: colorEstado, fontWeight: FontWeight.w600, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}