import 'package:flutter/material.dart';

// ============================================================
// PALETA DE COLORES — mismos valores que AppColorsDir (Direcciones
// Cliente) para que ambas pantallas luzcan exactamente igual.
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

  static const encabezado = navyOscuro;
  static const grisTexto = textoMuted;
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
  // Algunos vehículos no tienen un modelo asociado en los datos de
  // ejemplo (p. ej. el movimiento #1), por eso es opcional.
  final String? vehiculoNombre;
  final String cliente;
  final String fecha;
  final int mantNumero;
  final double monto;

  const MovimientoContable({
    required this.numero,
    required this.tipo,
    required this.categoria,
    required this.vehiculoId,
    this.vehiculoNombre,
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
// DATOS — los 15 movimientos completos
// ============================================================
const List<MovimientoContable> movimientosData = [
  MovimientoContable(
    numero: 1,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-023',
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
  MovimientoContable(
    numero: 3,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-013',
    vehiculoNombre: 'Hyundai Tucson',
    cliente: 'Cristian Muñoz',
    fecha: '30/06/2026',
    mantNumero: 13,
    monto: 270000,
  ),
  MovimientoContable(
    numero: 4,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.reparacion,
    vehiculoId: 'VT-012',
    vehiculoNombre: 'Kia Sportage',
    cliente: 'Camila Torres',
    fecha: '30/06/2026',
    mantNumero: 12,
    monto: 980000,
  ),
  MovimientoContable(
    numero: 5,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-011',
    vehiculoNombre: 'Renault Duster',
    cliente: 'Andrés Martínez',
    fecha: '30/06/2026',
    mantNumero: 11,
    monto: 180000,
  ),
  MovimientoContable(
    numero: 6,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.reparacion,
    vehiculoId: 'VT-010',
    vehiculoNombre: 'Isuzu D-Max',
    cliente: 'Carlos Fernández',
    fecha: '30/06/2026',
    mantNumero: 10,
    monto: 3200001,
  ),
  MovimientoContable(
    numero: 7,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-009',
    vehiculoNombre: 'Mazda BT-50',
    cliente: 'Andrés Martínez',
    fecha: '30/06/2026',
    mantNumero: 9,
    monto: 349998,
  ),
  MovimientoContable(
    numero: 8,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-008',
    vehiculoNombre: 'Mitsubishi L200',
    cliente: 'Carlos Fernández',
    fecha: '30/06/2026',
    mantNumero: 8,
    monto: 220000,
  ),
  MovimientoContable(
    numero: 9,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.blindamiento,
    vehiculoId: 'VT-007',
    vehiculoNombre: 'Chevrolet Colorado',
    cliente: 'Juan Esteban Gómez',
    fecha: '30/06/2026',
    mantNumero: 7,
    monto: 2399997,
  ),
  MovimientoContable(
    numero: 10,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-006',
    vehiculoNombre: 'Jeep Wrangler',
    cliente: 'Cristian Muñoz',
    fecha: '30/06/2026',
    mantNumero: 6,
    monto: 1750000,
  ),
  MovimientoContable(
    numero: 11,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-005',
    vehiculoNombre: 'Ford Ranger',
    cliente: 'Andrés Cárdenas',
    fecha: '30/06/2026',
    mantNumero: 5,
    monto: 650000,
  ),
  MovimientoContable(
    numero: 12,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.reparacion,
    vehiculoId: 'VT-004',
    vehiculoNombre: 'Nissan Frontier',
    cliente: 'Natalia Ramírez',
    fecha: '30/06/2026',
    mantNumero: 4,
    monto: 179999,
  ),
  MovimientoContable(
    numero: 13,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.reparacion,
    vehiculoId: 'VT-003',
    vehiculoNombre: 'Chevrolet D-Max',
    cliente: 'Andrés Martínez',
    fecha: '30/06/2026',
    mantNumero: 3,
    monto: 750000,
  ),
  MovimientoContable(
    numero: 14,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-002',
    vehiculoNombre: 'Toyota Hilux',
    cliente: 'Cristian Muñoz',
    fecha: '30/06/2026',
    mantNumero: 2,
    monto: 420000,
  ),
  MovimientoContable(
    numero: 15,
    tipo: TipoMovimiento.egreso,
    categoria: CategoriaMovimiento.mantenimiento,
    vehiculoId: 'VT-001',
    vehiculoNombre: 'Humvee Blindado',
    cliente: 'Andrés Cárdenas',
    fecha: '30/06/2026',
    mantNumero: 1,
    monto: 850000,
  ),
];

// ============================================================
// PANTALLA PRINCIPAL
// ============================================================
class MovimientosContablesScreen extends StatefulWidget {
  // Si embedded = true, no dibuja su propio Scaffold/AppBar (se usa
  // así dentro de main_shell_gerente.dart, igual que la pantalla de
  // Direcciones Cliente).
  final bool embedded;

  const MovimientosContablesScreen({super.key, this.embedded = false});

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
  final List<MovimientoContable> _movimientos = movimientosData;

  List<MovimientoContable> get _movimientosFiltrados {
    final query = _searchController.text.toLowerCase();
    return _movimientos.where((m) {
      final coincideTipo = _filtroTipo == 'Todos' ||
          m.tipoLabel.toLowerCase() == _filtroTipo.toLowerCase();
      final coincideBusqueda = query.isEmpty ||
          m.cliente.toLowerCase().contains(query) ||
          m.vehiculoId.toLowerCase().contains(query) ||
          m.categoriaLabel.toLowerCase().contains(query) ||
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

  // Corregido: antes el signo "-" quedaba después del "$" en los
  // balances negativos (ej. "$-12.683.998"). Ahora el signo va
  // siempre antes del símbolo de moneda ("-$12.683.998").
  String _formatoMoneda(double monto) {
    final esNegativo = monto < 0;
    final entero = monto.abs().round();
    final str = entero.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    final signo = esNegativo ? '-' : '';
    return '$signo\$${buffer.toString()}';
  }

  void _exportar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Exportando movimientos contables...',
          style: TextStyle(fontSize: 13),
        ),
        backgroundColor: AppColors.encabezado,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================

  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _buildTituloYExportar(),
        const SizedBox(height: 18),
        _buildStatsGrid(),
        const SizedBox(height: 18),
        _buildSearchBar(),
        const SizedBox(height: 14),
        _buildFiltros(),
        const SizedBox(height: 16),
        Text(
          '${_movimientosFiltrados.length} movimientos',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.encabezado,
          ),
        ),
        const SizedBox(height: 14),
        if (_movimientosFiltrados.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No se encontraron movimientos',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: AppColors.grisTexto,
                ),
              ),
            ),
          )
        else
          ..._movimientosFiltrados.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildMovimientoCard(m),
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildContent(context);
    }

    // Ya no dibuja su propio AppBar/header ("BIENVENIDO / Movimientos
    // Contables"): la pantalla principal no lo necesita, así que
    // solo se muestra el contenido (el cuadro navy con el título ya
    // cumple esa función).
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: SafeArea(child: _buildContent(context)),
    );
  }

  // ------------------------------------------------------------
  // CUADRO NAVY "Movimientos Contables" — MISMOS colores y estilo
  // que el cuadro "Direcciones del cliente": fondo navyOscuro,
  // borde dorado 1.2, radio 14, mismas tipografías. El botón
  // "Exportar" usa exactamente los mismos colores que el botón
  // "Agregar dirección" (fondo dorado, texto/ícono navy).
  // ------------------------------------------------------------
  Widget _buildTituloYExportar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyOscuro,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dorado, width: 1.2),
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
                    fontSize: 10.5,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600,
                    color: AppColors.doradoClaro,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Movimientos Contables',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Administra los movimientos financieros',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.subtitulo,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.star_rounded, size: 16, color: AppColors.dorado),
                    Icon(Icons.star_rounded, size: 16, color: AppColors.dorado),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _GoldButton(
            icon: Icons.file_download_outlined,
            label: 'Exportar',
            onTap: _exportar,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // GRID DE ESTADÍSTICAS 2x2 — bordes dorados en todo el cuadro,
  // con una franja de color a la izquierda según el tipo.
  // ------------------------------------------------------------
  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Ingresos',
                valor: _formatoMoneda(_totalIngresos),
                colorAcento: AppColors.verde,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Egresos',
                valor: _formatoMoneda(_totalEgresos),
                colorAcento: AppColors.rojo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Ajustes',
                valor: _formatoMoneda(_totalAjustes),
                colorAcento: AppColors.subtitulo,
                colorValor: AppColors.navyClaro,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Balance',
                valor: _formatoMoneda(_balance),
                colorAcento: _balance < 0 ? AppColors.rojo : AppColors.verde,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // BUSCADOR — borde dorado, mismo estilo que Direcciones Cliente
  // ------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dorado, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(color: AppColors.navyOscuro, fontSize: 13.5),
        decoration: const InputDecoration(
          hintText: 'Buscar por ID, concepto o cliente...',
          hintStyle: TextStyle(color: AppColors.grisTexto, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.grisTexto, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // FILTROS Todos / Egreso / Ingreso — bordes dorados
  // ------------------------------------------------------------
  Widget _buildFiltros() {
    final opciones = ['Todos', 'Egreso', 'Ingreso'];
    return Row(
      children: opciones.map((op) {
        final activo = _filtroTipo == op;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Material(
            color: activo ? AppColors.doradoClaro.withOpacity(0.28) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() => _filtroTipo = op),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.dorado,
                    width: activo ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  op,
                  style: TextStyle(
                    color: activo ? AppColors.doradoMezcla : AppColors.grisTexto,
                    fontSize: 12.5,
                    fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ------------------------------------------------------------
  // TARJETA DE MOVIMIENTO — borde dorado en todo el cuadro más una
  // franja de color a la izquierda según el tipo (rojo/verde).
  // ------------------------------------------------------------
  Widget _buildMovimientoCard(MovimientoContable m) {
    final esEgreso = m.tipo == TipoMovimiento.egreso;
    final colorTipo = esEgreso
        ? AppColors.rojo
        : (m.tipo == TipoMovimiento.ingreso ? AppColors.verde : AppColors.subtitulo);
    final fondoTipo = esEgreso
        ? AppColors.rojoFondo
        : (m.tipo == TipoMovimiento.ingreso ? AppColors.verdeFondo : AppColors.naranjaFondo);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: colorTipo, width: 4),
            top: BorderSide(color: AppColors.dorado, width: 1.2),
            right: BorderSide(color: AppColors.dorado, width: 1.2),
            bottom: BorderSide(color: AppColors.dorado, width: 1.2),
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconoCategoria(m.categoria, fondoTipo),
            const SizedBox(width: 12),
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
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
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
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: AppColors.navyClaro,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                      children: [
                        TextSpan(text: '${m.categoriaLabel} — Vehículo: '),
                        TextSpan(
                          text: m.vehiculoNombre == null
                              ? m.vehiculoId
                              : '${m.vehiculoId} — ${m.vehiculoNombre}',
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
                  const SizedBox(height: 10),
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
                                color: AppColors.grisTexto,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Mant. #${m.mantNumero}',
                              style: const TextStyle(
                                color: AppColors.grisTexto,
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
      ),
    );
  }

  // Íconos por categoría.
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

// ==================== WIDGETS AUXILIARES ====================

// Botón dorado — MISMOS colores/tamaños que "Agregar dirección" en
// Direcciones Cliente (fondo dorado, texto/ícono navy).
class _GoldButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GoldButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dorado,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: AppColors.encabezado),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.encabezado,
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
}

// Tarjeta de estadística — borde dorado completo + franja de color
// a la izquierda según el tipo de dato que muestra.
class _StatCard extends StatelessWidget {
  final String label;
  final String valor;
  final Color colorAcento;
  final Color? colorValor;

  const _StatCard({
    required this.label,
    required this.valor,
    required this.colorAcento,
    this.colorValor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: colorAcento, width: 4),
          top: BorderSide(color: AppColors.dorado, width: 1.2),
          right: BorderSide(color: AppColors.dorado, width: 1.2),
          bottom: BorderSide(color: AppColors.dorado, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.doradoOscuro.withOpacity(0.06),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.grisTexto, fontSize: 11.5),
          ),
          const SizedBox(height: 5),
          Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorValor ?? colorAcento,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}