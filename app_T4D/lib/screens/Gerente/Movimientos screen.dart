import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T4D - Movimientos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: MovColors.background,
        fontFamily: 'Roboto',
      ),
      home: const MovimientosScreen(),
    );
  }
}

// ==================== PALETA DE COLORES ====================
// Paleta dorado/marfil de la vista de Gerente.
class MovColors {
  static const Color background = Color(0xFFF7F1E3); // FONDO
  static const Color navy = Color(0xFF13202E); // ENCABEZADO
  static const Color white = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF20213B);
  static const Color textGrey = Color(0xFF8A8CA5);

  static const Color gold = Color(0xFFD4A743); // DORADO
  static const Color goldDark = Color(0xFF8C6B3F); // DORADO_OSCURO
  static const Color goldLight = Color(0xFFE7C98A); // DORADO_CLARO / TEXTO_ENC

  static const Color green = Color(0xFF1FA35A);
  static const Color greenBg = Color(0xFFE3F9EC);
  static const Color red = Color(0xFFE04B4B);
  static const Color redBg = Color(0xFFFCE7E7);
  static const Color borderLight = Color(0xFFE7E5F3);
  static const Color cardShadow = Color(0x14000000);
}

// ==================== MODELO ====================
enum MovTipo { entrada, salida }

class MovimientoRecord {
  final DateTime fecha;
  final MovTipo tipo;
  final String producto;
  final String usuario;
  final String motivo;
  final int cantidad; // positivo o negativo

  const MovimientoRecord({
    required this.fecha,
    required this.tipo,
    required this.producto,
    required this.usuario,
    required this.motivo,
    required this.cantidad,
  });
}

String _formatFecha(DateTime d) {
  const meses = [
    '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'
  ];
  final dd = d.day.toString().padLeft(2, '0');
  final mm = meses[d.month - 1];
  final yyyy = d.year.toString();
  int h = d.hour % 12;
  if (h == 0) h = 12;
  final min = d.minute.toString().padLeft(2, '0');
  final ampm = d.hour < 12 ? 'a. m.' : 'p. m.';
  return '$dd/$mm/$yyyy, $h:$min $ampm';
}

String _formatCantidad(int c) {
  final abs = c.abs();
  final str = abs.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => '.',
      );
  return c >= 0 ? '+$str' : '-$str';
}

final List<MovimientoRecord> mockMovimientos = [
  MovimientoRecord(
    fecha: DateTime(2026, 7, 2, 14, 50),
    tipo: MovTipo.salida,
    producto: 'Llantaa',
    usuario: 'Juan',
    motivo: 'Ajuste de stock desde edición de producto',
    cantidad: -3,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 7, 2, 14, 49),
    tipo: MovTipo.entrada,
    producto: 'Llantaa',
    usuario: 'Juan',
    motivo: 'Ajuste de stock desde edición de producto',
    cantidad: 2,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 7, 2, 14, 47),
    tipo: MovTipo.salida,
    producto: 'Llantaa',
    usuario: 'Juan',
    motivo: 'Ajuste de stock desde edición de producto',
    cantidad: -23,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 7, 2, 14, 46),
    tipo: MovTipo.entrada,
    producto: 'Llantaa',
    usuario: 'Juan',
    motivo: 'Ajuste de stock desde edición de producto',
    cantidad: 29,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 7, 1, 0, 12),
    tipo: MovTipo.salida,
    producto: 'Amortiguador Delantero Reforzado',
    usuario: 'Juan',
    motivo: 'Ajuste de stock desde edición de producto',
    cantidad: -7,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 32),
    tipo: MovTipo.entrada,
    producto: 'Correa de Distribución',
    usuario: 'Camilo',
    motivo: 'Stock inicial al crear producto',
    cantidad: 15,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 22),
    tipo: MovTipo.entrada,
    producto: 'Kit de Embrague Toyota',
    usuario: 'Juan',
    motivo: 'Stock inicial al crear producto',
    cantidad: 780000,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 21),
    tipo: MovTipo.entrada,
    producto: 'Disco de Freno Delantero',
    usuario: 'Juan',
    motivo: 'Stock inicial al crear producto',
    cantidad: 18,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 21),
    tipo: MovTipo.entrada,
    producto: 'Amortiguador Delantero Reforzado',
    usuario: 'Juan',
    motivo: 'Stock inicial al crear producto',
    cantidad: 12,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 20),
    tipo: MovTipo.entrada,
    producto: 'Filtro de Aire Militar',
    usuario: 'Juan',
    motivo: 'Stock inicial al crear producto',
    cantidad: 25,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 19),
    tipo: MovTipo.entrada,
    producto: 'Líquido de Frenos DOT 4',
    usuario: 'Juan',
    motivo: 'Stock inicial al crear producto',
    cantidad: 40,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 18),
    tipo: MovTipo.entrada,
    producto: 'Neumático Todo Terreno 265/70R17',
    usuario: 'Juan',
    motivo: 'Stock inicial al crear producto',
    cantidad: 16,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 17),
    tipo: MovTipo.entrada,
    producto: 'Batería 12V 900A',
    usuario: 'Juan',
    motivo: 'Stock inicial al crear producto',
    cantidad: 10,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 16),
    tipo: MovTipo.entrada,
    producto: 'Pastillas de Freno Delanteras',
    usuario: 'Juan',
    motivo: 'Stock inicial al crear producto',
    cantidad: 20,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 15),
    tipo: MovTipo.entrada,
    producto: 'Filtro de Aceite Toyota Hilux',
    usuario: 'Juan',
    motivo: 'Stock inicial al crear producto',
    cantidad: 30,
  ),
  MovimientoRecord(
    fecha: DateTime(2026, 6, 25, 6, 13),
    tipo: MovTipo.entrada,
    producto: 'Aceite Mobil 15W-40 1L',
    usuario: 'Juan',
    motivo: 'Stock inicial al crear producto',
    cantidad: 50,
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class MovimientosScreen extends StatefulWidget {
  final bool embedded;
  final String userName;

  const MovimientosScreen({
    super.key,
    this.embedded = false,
    this.userName = 'Gerente',
  });

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroTipo = 'Todos'; // Todos | Entrada | Salida
  String _filtroExtra = 'Todos';

  List<MovimientoRecord> get _filtrados {
    return mockMovimientos.where((m) {
      final coincideTipo = _filtroTipo == 'Todos' ||
          (_filtroTipo == 'Entrada' && m.tipo == MovTipo.entrada) ||
          (_filtroTipo == 'Salida' && m.tipo == MovTipo.salida);

      final q = _searchController.text.trim().toLowerCase();
      final coincideBusqueda = q.isEmpty ||
          m.producto.toLowerCase().contains(q) ||
          m.usuario.toLowerCase().contains(q);

      return coincideTipo && coincideBusqueda;
    }).toList();
  }

  int get _totalEntradas => mockMovimientos
      .where((m) => m.tipo == MovTipo.entrada)
      .fold(0, (sum, m) => sum + m.cantidad);

  int get _totalSalidas => mockMovimientos
      .where((m) => m.tipo == MovTipo.salida)
      .fold(0, (sum, m) => sum + m.cantidad.abs());

  void _limpiarFiltros() {
    setState(() {
      _searchController.clear();
      _filtroTipo = 'Todos';
      _filtroExtra = 'Todos';
    });
  }

  Widget _buildContent(BuildContext context) {
    final filtrados = _filtrados;
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        _TitleCard(
          onExportar: () {},
          onActualizar: () => setState(() {}),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Total Entradas',
                value: _formatCantidad(_totalEntradas).replaceFirst('+', ''),
                subtitle: 'unidades en el periodo filtrado',
                valueColor: MovColors.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                title: 'Total Salidas',
                value: _totalSalidas.toString(),
                subtitle: 'unidades en el periodo filtrado',
                valueColor: MovColors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _FiltersCard(
          controller: _searchController,
          filtroTipo: _filtroTipo,
          filtroExtra: _filtroExtra,
          onFiltroTipoChanged: (v) => setState(() => _filtroTipo = v),
          onFiltroExtraChanged: (v) => setState(() => _filtroExtra = v),
          onBuscarChanged: (_) => setState(() {}),
          onLimpiar: _limpiarFiltros,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            'Historial de Movimientos (${filtrados.length})',
            style: const TextStyle(
              color: MovColors.textDark,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        for (final m in filtrados)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MovimientoCard(movimiento: m),
          ),
        if (filtrados.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                'No hay movimientos que coincidan con el filtro',
                style: TextStyle(color: MovColors.textGrey, fontSize: 12.5),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildContent(context);
    }
    return Scaffold(
      backgroundColor: MovColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopHeader(userName: widget.userName),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }
}

// ==================== HEADER SUPERIOR ====================
class _TopHeader extends StatelessWidget {
  final String userName;
  const _TopHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MovColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Builder(
            builder: (context) => InkWell(
              onTap: () => Scaffold.maybeOf(context)?.openDrawer(),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.menu, color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: MovColors.gold,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              'T4D',
              style: TextStyle(
                color: MovColors.navy,
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BIENVENIDO',
                  style: TextStyle(
                    color: MovColors.goldLight,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Movimientos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.notifications_none, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 9,
                  backgroundColor: MovColors.gold,
                  child: const Icon(Icons.person, size: 11, color: MovColors.navy),
                ),
                const SizedBox(width: 5),
                Text(userName,
                    style: const TextStyle(color: Colors.white, fontSize: 11.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE TÍTULO ====================
class _TitleCard extends StatelessWidget {
  final VoidCallback onExportar;
  final VoidCallback onActualizar;

  const _TitleCard({required this.onExportar, required this.onActualizar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MovColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: MovColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Movimientos de Inventario',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: MovColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Historial de entradas y salidas',
            style: TextStyle(fontSize: 12, color: MovColors.textGrey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(height: 2, color: MovColors.gold.withOpacity(0.5)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.star, size: 12, color: MovColors.gold),
              ),
              Expanded(
                child: Container(height: 2, color: MovColors.gold.withOpacity(0.5)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _PillButton(
                  icon: Icons.file_download_outlined,
                  label: 'Exportar',
                  showChevron: true,
                  bg: MovColors.gold,
                  fg: MovColors.navy,
                  onTap: onExportar,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PillButton(
                  icon: Icons.refresh_rounded,
                  label: 'Actualizar',
                  bg: MovColors.goldDark,
                  fg: Colors.white,
                  onTap: onActualizar,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final bool showChevron;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
              if (showChevron) ...[
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 16, color: fg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== TARJETAS DE ESTADÍSTICAS ====================
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color valueColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MovColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: MovColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: MovColors.textGrey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: valueColor),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 10.5, color: MovColors.textGrey)),
        ],
      ),
    );
  }
}

// ==================== TARJETA DE FILTROS ====================
class _FiltersCard extends StatelessWidget {
  final TextEditingController controller;
  final String filtroTipo;
  final String filtroExtra;
  final ValueChanged<String> onFiltroTipoChanged;
  final ValueChanged<String> onFiltroExtraChanged;
  final ValueChanged<String> onBuscarChanged;
  final VoidCallback onLimpiar;

  const _FiltersCard({
    required this.controller,
    required this.filtroTipo,
    required this.filtroExtra,
    required this.onFiltroTipoChanged,
    required this.onFiltroExtraChanged,
    required this.onBuscarChanged,
    required this.onLimpiar,
  });

  static const List<String> _extra = ['Todos', 'Hoy', 'Últimos 7 días', 'Últimos 30 días'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MovColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: MovColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.filter_alt_outlined, size: 16, color: MovColors.gold),
              SizedBox(width: 6),
              Text('Filtros y Búsqueda',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: MovColors.textDark)),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            onChanged: onBuscarChanged,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Buscar por producto o usuario...',
              hintStyle: const TextStyle(fontSize: 11.5, color: MovColors.textGrey),
              prefixIcon: const Icon(Icons.search, size: 18, color: MovColors.textGrey),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: MovColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: MovColors.borderLight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Chip(label: 'Todos', selected: filtroTipo == 'Todos', onTap: () => onFiltroTipoChanged('Todos')),
              _Chip(label: 'Entrada', selected: filtroTipo == 'Entrada', onTap: () => onFiltroTipoChanged('Entrada')),
              _Chip(label: 'Salida', selected: filtroTipo == 'Salida', onTap: () => onFiltroTipoChanged('Salida')),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: MovColors.borderLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: filtroExtra,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: MovColors.textGrey),
                    style: const TextStyle(fontSize: 12, color: MovColors.textDark),
                    items: _extra.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) {
                      if (v != null) onFiltroExtraChanged(v);
                    },
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onLimpiar,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6B7280),
                  side: const BorderSide(color: MovColors.borderLight),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.close, size: 14),
                label: const Text('Limpiar', style: TextStyle(fontSize: 11.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? MovColors.gold : const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? MovColors.gold : MovColors.borderLight),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? MovColors.navy : MovColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== TARJETA DE MOVIMIENTO ====================
class _MovimientoCard extends StatelessWidget {
  final MovimientoRecord movimiento;

  const _MovimientoCard({required this.movimiento});

  @override
  Widget build(BuildContext context) {
    final esEntrada = movimiento.tipo == MovTipo.entrada;
    final badgeColor = esEntrada ? MovColors.green : MovColors.red;
    final badgeBg = esEntrada ? MovColors.greenBg : MovColors.redBg;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MovColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: MovColors.cardShadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatFecha(movimiento.fecha),
                style: const TextStyle(fontSize: 11, color: MovColors.textGrey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  esEntrada ? 'Entrada' : 'Salida',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movimiento.producto,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: MovColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 12, color: MovColors.textGrey),
                        children: [
                          TextSpan(
                            text: movimiento.usuario,
                            style: const TextStyle(color: MovColors.goldDark, fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: ' · ${movimiento.motivo}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatCantidad(movimiento.cantidad),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: badgeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}