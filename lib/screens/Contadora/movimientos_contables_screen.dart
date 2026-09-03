import 'package:flutter/material.dart';

// ============================================================
// PALETA DE COLORES
// ============================================================
class AppColors {
  static const dorado = Color(0xFFC9962E);
  static const doradoOscuro = Color(0xFF8C6B2E);
  static const doradoClaro = Color(0xFFE8C97A);
  static const doradoMezcla = Color(0xFFAB812E); // punto medio dorado/doradoOscuro
  static const fondo = Color(0xFFFAF3E4);
  static const navyOscuro = Color(0xFF0F1B2E);
  static const navyClaro = Color(0xFF16233A);
  static const subtitulo = Color(0xFF8FA3C4);
  static const verde = Color(0xFF2E9E5B);
  static const verdeFondo = Color(0xFFDDF2E1);
  static const naranja = Color(0xFFA17A2E);
  static const naranjaFondo = Color(0xFFF5E3C3);
  static const rojo = Color(0xFFC0293B);
  static const rojoFondo = Color(0xFFFADCE0);
  static const textoMuted = Color(0xFF6B7280);
  static const enlace = Color(0xFF2563EB);
}

// ============================================================
// MODELO
// ============================================================
enum TipoMovimiento { ingreso, egreso, ajuste }

enum CategoriaMovimiento { mantenimiento, reparacion, blindamiento }

class MovimientoContable {
  final int numero;
  final TipoMovimiento tipo;
  final CategoriaMovimiento categoria;
  final String vehiculoId;
  final String vehiculoNombre;
  final String cliente;
  final String fecha;
  final int mantNumero;
  final double monto;

  const MovimientoContable({
    required this.numero,
    required this.tipo,
    required this.categoria,
    required this.vehiculoId,
    required this.vehiculoNombre,
    required this.cliente,
    required this.fecha,
    required this.mantNumero,
    required this.monto,
  });

  String get tipoLabel {
    switch (tipo) {
      case TipoMovimiento.ingreso:
        return 'Ingreso';
      case TipoMovimiento.egreso:
        return 'Egreso';
      case TipoMovimiento.ajuste:
        return 'Ajuste';
    }
  }

  String get categoriaLabel {
    switch (categoria) {
      case CategoriaMovimiento.mantenimiento:
        return 'Mantenimiento';
      case CategoriaMovimiento.reparacion:
        return 'Reparación';
      case CategoriaMovimiento.blindamiento:
        return 'Blindamiento';
    }
  }
}

// ============================================================
// PANTALLA PRINCIPAL
// ============================================================
class MovimientosContablesScreen extends StatefulWidget {
  const MovimientosContablesScreen({super.key});

  @override
  State<MovimientosContablesScreen> createState() =>
      _MovimientosContablesScreenState();
}

class _MovimientosContablesScreenState
    extends State<MovimientosContablesScreen> {
  String _filtroTipo = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  // ------------------------------------------------------------
  // TODO: Reemplaza esto por tu fetch real a Supabase
  // (tabla movimientos_contables + join con mantenimiento/vehiculos)
  // ------------------------------------------------------------
  final List<MovimientoContable> _movimientos = const [
    MovimientoContable(
      numero: 1,
      tipo: TipoMovimiento.egreso,
      categoria: CategoriaMovimiento.mantenimiento,
      vehiculoId: 'VT-013',
      vehiculoNombre: 'Hyundai Tucson',
      cliente: 'Sara Jiménez',
      fecha: '02/07/2026',
      mantNumero: 15,
      monto: 34000,
    ),
    MovimientoContable(
      numero: 2,
      tipo: TipoMovimiento.egreso,
      categoria: CategoriaMovimiento.mantenimiento,
      vehiculoId: 'VT-014',
      vehiculoNombre: 'Toyota Prado',
      cliente: 'Felipe Torres',
      fecha: '30/06/2026',
      mantNumero: 14,
      monto: 450003,
    ),
    // ... agrega el resto de tus 15 movimientos aquí
  ];

  List<MovimientoContable> get _movimientosFiltrados {
    final query = _searchController.text.toLowerCase();
    return _movimientos.where((m) {
      final coincideTipo = _filtroTipo == 'Todos' ||
          m.tipoLabel.toLowerCase() == _filtroTipo.toLowerCase();
      final coincideBusqueda = query.isEmpty ||
          m.cliente.toLowerCase().contains(query) ||
          m.vehiculoId.toLowerCase().contains(query) ||
          m.numero.toString().contains(query);
      return coincideTipo && coincideBusqueda;
    }).toList();
  }

  double get _totalIngresos => _movimientos
      .where((m) => m.tipo == TipoMovimiento.ingreso)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get _totalEgresos => _movimientos
      .where((m) => m.tipo == TipoMovimiento.egreso)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get _totalAjustes => _movimientos
      .where((m) => m.tipo == TipoMovimiento.ajuste)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get _balance => _totalIngresos - _totalEgresos + _totalAjustes;

  String _formatoMoneda(double monto) {
    final entero = monto.round();
    final str = entero.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return '\$${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _buildStatsGrid(),
                  const SizedBox(height: 14),
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  _buildFiltros(),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '${_movimientosFiltrados.length} MOVIMIENTOS',
                      style: const TextStyle(
                        color: AppColors.subtitulo,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._movimientosFiltrados
                      .map((m) => _buildMovimientoCard(m)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: const BoxDecoration(
        color: AppColors.navyOscuro,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONTADORA · MOVIMIENTOS',
                  style: TextStyle(
                    color: AppColors.doradoClaro,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Movimientos Contables',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Administra los movimientos financieros',
                  style: TextStyle(
                    color: AppColors.subtitulo,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildExportButton(),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          // TODO: lógica de exportación (Excel/PDF)
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.dorado,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.file_download_outlined,
                  color: AppColors.navyOscuro, size: 16),
              SizedBox(width: 6),
              Text(
                'Exportar',
                style: TextStyle(
                  color: AppColors.navyOscuro,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TARJETAS DE ESTADÍSTICAS
  // ------------------------------------------------------------
  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                label: 'Ingresos',
                value: _formatoMoneda(_totalIngresos),
                barColor: AppColors.verde,
                valueColor: AppColors.verde,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard(
                label: 'Egresos',
                value: _formatoMoneda(_totalEgresos),
                barColor: AppColors.rojo,
                valueColor: AppColors.rojo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _statCard(
                label: 'Ajustes',
                value: _formatoMoneda(_totalAjustes),
                barColor: AppColors.subtitulo,
                valueColor: AppColors.navyClaro,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard(
                label: 'Balance',
                value: _formatoMoneda(_balance),
                barColor: _balance < 0 ? AppColors.rojo : AppColors.verde,
                valueColor: _balance < 0 ? AppColors.rojo : AppColors.verde,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required Color barColor,
    required Color valueColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
        border: Border(left: BorderSide(color: barColor, width: 4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textoMuted,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BUSCADOR
  // ------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(color: AppColors.navyOscuro, fontSize: 13.5),
        decoration: const InputDecoration(
          hintText: 'Buscar por ID, concepto o cliente...',
          hintStyle: TextStyle(color: AppColors.subtitulo, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: AppColors.subtitulo, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // FILTROS
  // ------------------------------------------------------------
  Widget _buildFiltros() {
    final opciones = ['Todos', 'Egreso', 'Ingreso'];
    return Row(
      children: opciones.map((op) {
        final activo = _filtroTipo == op;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _filtroTipo = op),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: activo
                    ? AppColors.doradoClaro.withOpacity(0.25)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: activo ? AppColors.dorado : const Color(0xFFD3D1C7),
                  width: activo ? 1.5 : 1,
                ),
              ),
              child: Text(
                op,
                style: TextStyle(
                  color: activo ? AppColors.doradoMezcla : AppColors.textoMuted,
                  fontSize: 12.5,
                  fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ------------------------------------------------------------
  // TARJETA DE MOVIMIENTO
  // ------------------------------------------------------------
  Widget _buildMovimientoCard(MovimientoContable m) {
    final esEgreso = m.tipo == TipoMovimiento.egreso;
    final colorTipo = esEgreso
        ? AppColors.rojo
        : (m.tipo == TipoMovimiento.ingreso ? AppColors.verde : AppColors.subtitulo);
    final fondoTipo = esEgreso
        ? AppColors.rojoFondo
        : (m.tipo == TipoMovimiento.ingreso ? AppColors.verdeFondo : AppColors.naranjaFondo);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(14)),
        border: Border(left: BorderSide(color: colorTipo, width: 4)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconoCategoria(m.categoria, fondoTipo),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '#${m.numero}',
                      style: const TextStyle(
                        color: AppColors.navyClaro,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: fondoTipo,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        m.tipoLabel,
                        style: TextStyle(
                          color: colorTipo,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.navyClaro,
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(text: '${m.categoriaLabel} — Vehículo: '),
                      TextSpan(
                        text: m.vehiculoId,
                        style: const TextStyle(
                          color: AppColors.enlace,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: ' — Cliente: '),
                      TextSpan(
                        text: m.cliente,
                        style: const TextStyle(
                          color: AppColors.enlace,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${m.cliente} · ${m.fecha}',
                            style: const TextStyle(
                              color: AppColors.textoMuted,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Mant. #${m.mantNumero}',
                            style: const TextStyle(
                              color: AppColors.textoMuted,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _formatoMoneda(m.monto),
                      style: TextStyle(
                        color: colorTipo,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Íconos por categoría — evita el look genérico de "círculo + emoji",
  // usa contenedor redondeado con el tono del movimiento.
  Widget _iconoCategoria(CategoriaMovimiento categoria, Color fondo) {
    IconData icono;
    switch (categoria) {
      case CategoriaMovimiento.mantenimiento:
        icono = Icons.build_outlined;
        break;
      case CategoriaMovimiento.reparacion:
        icono = Icons.car_repair_outlined;
        break;
      case CategoriaMovimiento.blindamiento:
        icono = Icons.shield_outlined;
        break;
    }
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icono, size: 18, color: AppColors.doradoMezcla),
    );
  }
}