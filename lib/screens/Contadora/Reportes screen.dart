import 'package:flutter/material.dart';
import '../../models/reporte.dart';
// import '../services/reportes_service.dart'; // ← lo conectas cuando pases de mock a datos reales

class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const navy = Color(0xFF13202E);
  static const navyOscuro = Color(0xFF101F3C);
  static const navyClaro = Color(0xFF1B2B4E);
  static const azul = Color(0xFF3B82F6);
  static const morado = Color(0xFF8B5CF6);
  static const verde = Color(0xFF1F9D55);
  static const verdeFondo = Color(0xFFE3F7E9);
  static const rojo = Color(0xFFC0392B);
  static const rojoFondo = Color(0xFFFBE2DF);
  static const naranja = Color(0xFFC98A1B);
  static const naranjaFondo = Color(0xFFFBF0DD);
  static const textoMuted = Color(0xFF6B7280);
  static const subtitulo = Color(0xFF8FA3C4);
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

  // Conteo de estado general del inventario (mock, independiente del modelo
  // ResumenReporte). Cuando conectes el backend, reemplázalos por los
  // valores reales que te devuelva tu servicio (o agrégalos al modelo).
  int _stockAlto = 8;
  int _stockMedio = 2;

  // Paleta cíclica para los puntos/barras de "Distribución por categoría"
  static const List<Color> _coloresCategoria = [
    AppColors.azul,
    AppColors.azul,
    AppColors.morado,
    AppColors.naranja,
    AppColors.rojo,
  ];

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
          ProductoDestacado(
            posicion: 5,
            nombre: 'Disco de Freno Delantero',
            stock: 18,
            valor: 3240000,
            estado: 'alto',
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

    final rolCrudo = (widget.usuario?['rol'] ?? 'administrador').toString().toUpperCase();

    return Container(
      color: AppColors.fondo,
      child: RefreshIndicator(
        onRefresh: _cargarReporte,
        child: _cargando || r == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Encabezado oscuro, igual estilo que el resto de la app
                  _encabezado(rolCrudo),
                  const SizedBox(height: 14),

                  // Tarjetas de estadísticas (oscuras, con icono)
                  Row(
                    children: [
                      Expanded(
                        child: _tarjetaEstadistica(
                          titulo: 'Total Productos',
                          valor: '${r.totalProductos}',
                          subtitulo: 'en inventario',
                          color: AppColors.dorado,
                          icono: Icons.inventory_2_outlined,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _tarjetaEstadistica(
                          titulo: 'Valor Total',
                          valor: _formatoCompacto(r.valorTotal),
                          subtitulo: 'en stock',
                          color: AppColors.azul,
                          icono: Icons.account_balance_wallet_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _tarjetaEstadistica(
                          titulo: 'Stock Crítico',
                          valor: '${r.stockBajo}',
                          subtitulo: 'productos en riesgo',
                          color: AppColors.rojo,
                          icono: Icons.warning_amber_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _tarjetaEstadistica(
                          titulo: 'Movimientos',
                          valor: '${r.movimientosPeriodo}',
                          subtitulo: 'en el periodo',
                          color: AppColors.verde,
                          icono: Icons.sync_alt,
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
                        _tituloConBarra('Distribución por Categoría'),
                        const SizedBox(height: 14),
                        ...r.categorias.asMap().entries.map((entry) {
                          final indice = entry.key;
                          final c = entry.value;
                          final color = _coloresCategoria[indice % _coloresCategoria.length];
                          final porcentaje =
                              r.totalProductos == 0 ? 0 : (c.cantidad / r.totalProductos * 100);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                    ),
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
                                    const SizedBox(width: 6),
                                    Text(
                                      '${porcentaje.round()}%',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textoMuted,
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
                                    valueColor: AlwaysStoppedAnimation(color),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
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
                        _tituloConBarra('Productos Destacados'),
                        const SizedBox(height: 10),
                        ...r.destacados.map((p) => _filaDestacado(p)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Resumen de estado de stock (tarjeta oscura)
                  _resumenEstadoStock(r.stockBajo),
                ],
              ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // ENCABEZADO OSCURO (mismo estilo que Historial de Precios / Inventario)
  // ---------------------------------------------------------------------
  Widget _encabezado(String rolCrudo) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.navyOscuro, AppColors.navyClaro],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$rolCrudo · REPORTES',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dorado,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Reportes del Sistema',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Resumen y estadísticas del inventario',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tituloConBarra(String texto) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.dorado,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _tarjetaEstadistica({
    required String titulo,
    required String valor,
    required String subtitulo,
    required Color color,
    required IconData icono,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  titulo.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icono, size: 16, color: color),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
    final esPrimero = p.posicion == 1;

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
                color: esPrimero ? AppColors.dorado : AppColors.doradoClaro.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${p.posicion}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: esPrimero ? Colors.white : AppColors.doradoOscuro,
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

  // ---------------------------------------------------------------------
  // RESUMEN DE ESTADO DE STOCK (tarjeta oscura con 3 columnas)
  // ---------------------------------------------------------------------
  Widget _resumenEstadoStock(int stockBajo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.dorado,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Resumen de Estado de Stock',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _bloqueEstado('$_stockAlto', 'Stock Alto', AppColors.verde, AppColors.verdeFondo),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _bloqueEstado(
                    '$_stockMedio', 'Stock Medio', AppColors.naranja, AppColors.naranjaFondo),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _bloqueEstado('$stockBajo', 'Stock Bajo', AppColors.rojo, AppColors.rojoFondo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bloqueEstado(String valor, String label, Color color, Color fondo) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: fondo.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(valor, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.subtitulo),
          ),
        ],
      ),
    );
  }
}