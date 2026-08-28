import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T4D - Historial de Precios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.fondo,
        fontFamily: 'Roboto',
      ),
      home: const HistorialPreciosScreen(),
    );
  }
}

// ==================== PALETA COMPARTIDA ====================
class AppColors {
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const encabezado = Color(0xFF13202E);

  static const white = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF20213B);
  static const grayText = Color(0xFF6B7280);

  static const green = Color(0xFF1FA35A);
  static const greenBg = Color(0xFFE3F9EC);

  static const red = Color(0xFFE04B4B);
  static const redBg = Color(0xFFFCE7E7);

  // Alias adicionales para que otras pantallas (Cliente, Tareas, etc.)
  // que ya usaban estos nombres puedan reutilizar esta misma paleta.
  static const navy = encabezado;
  static const background = fondo;
  static const panelDark = encabezado;
  static const gold = dorado;
  static const goldLight = doradoClaro;
  static const goldDark = doradoOscuro;
  static const goldBg = doradoClaro;
  static const borderLight = dorado;
  static const cardWhiteSubtitle = grayText;
  static const neutral = grayText;
  static const orange = doradoOscuro;
  static const orangeBg = doradoClaro;
}

// ==================== MODELO ====================
enum CambioTipo { incremento, disminucion }

class PriceChangeRecord {
  final DateTime fecha;
  final String producto;
  final String usuario;
  final double precioAnterior;
  final double precioNuevo;

  const PriceChangeRecord({
    required this.fecha,
    required this.producto,
    required this.usuario,
    required this.precioAnterior,
    required this.precioNuevo,
  });

  CambioTipo get tipo =>
      precioNuevo >= precioAnterior ? CambioTipo.incremento : CambioTipo.disminucion;

  double get porcentaje =>
      precioAnterior == 0 ? 0 : ((precioNuevo - precioAnterior) / precioAnterior) * 100;
}

String _fmtFecha(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final yyyy = d.year.toString();
  int h = d.hour % 12;
  if (h == 0) h = 12;
  final min = d.minute.toString().padLeft(2, '0');
  final ampm = d.hour < 12 ? 'a. m.' : 'p. m.';
  return '$dd/$mm/$yyyy, $h:$min $ampm';
}

String _fmtPrecio(double v) {
  final entero = v.round().toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => '.',
      );
  return '\$$entero';
}

final List<PriceChangeRecord> mockPriceChanges = [
  PriceChangeRecord(
    fecha: DateTime(2026, 7, 2, 15, 10),
    producto: 'Llantaa',
    usuario: 'Gerente',
    precioAnterior: 320000,
    precioNuevo: 345000,
  ),
  PriceChangeRecord(
    fecha: DateTime(2026, 7, 1, 9, 30),
    producto: 'Amortiguador Delantero Reforzado',
    usuario: 'Gerente',
    precioAnterior: 185000,
    precioNuevo: 175000,
  ),
  PriceChangeRecord(
    fecha: DateTime(2026, 6, 28, 11, 5),
    producto: 'Kit de Embrague Toyota',
    usuario: 'Gerente',
    precioAnterior: 890000,
    precioNuevo: 950000,
  ),
  PriceChangeRecord(
    fecha: DateTime(2026, 6, 27, 16, 45),
    producto: 'Batería 12V 900A',
    usuario: 'Gerente',
    precioAnterior: 420000,
    precioNuevo: 399000,
  ),
  PriceChangeRecord(
    fecha: DateTime(2026, 6, 26, 8, 20),
    producto: 'Filtro de Aceite Toyota Hilux',
    usuario: 'Gerente',
    precioAnterior: 45000,
    precioNuevo: 48000,
  ),
  PriceChangeRecord(
    fecha: DateTime(2026, 6, 25, 14, 0),
    producto: 'Correa de Distribución',
    usuario: 'Gerente',
    precioAnterior: 95000,
    precioNuevo: 105000,
  ),
  PriceChangeRecord(
    fecha: DateTime(2026, 6, 20, 10, 15),
    producto: 'Neumático Todo Terreno 265/70R17',
    usuario: 'Gerente',
    precioAnterior: 610000,
    precioNuevo: 590000,
  ),
];

// ==================== PANTALLA PRINCIPAL ====================
class HistorialPreciosScreen extends StatefulWidget {
  final bool embedded;
  final String userName;

  const HistorialPreciosScreen({
    super.key,
    this.embedded = false,
    this.userName = 'Gerente',
  });

  @override
  State<HistorialPreciosScreen> createState() => _HistorialPreciosScreenState();
}

class _HistorialPreciosScreenState extends State<HistorialPreciosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroTipo = 'Todos'; // Todos | Incremento | Disminución

  List<PriceChangeRecord> get _filtrados {
    return mockPriceChanges.where((c) {
      final coincideTipo = _filtroTipo == 'Todos' ||
          (_filtroTipo == 'Incremento' && c.tipo == CambioTipo.incremento) ||
          (_filtroTipo == 'Disminución' && c.tipo == CambioTipo.disminucion);

      final q = _searchController.text.trim().toLowerCase();
      final coincideBusqueda = q.isEmpty || c.producto.toLowerCase().contains(q);

      return coincideTipo && coincideBusqueda;
    }).toList();
  }

  int get _totalIncrementos =>
      mockPriceChanges.where((c) => c.tipo == CambioTipo.incremento).length;
  int get _totalDisminuciones =>
      mockPriceChanges.where((c) => c.tipo == CambioTipo.disminucion).length;

  // NOTA: aquí ya NO se llama _TitleCard. Ese panel repetía el título
  // "Historial de Precios" que ya aparece arriba junto al logo, así que
  // se eliminó por completo para que el nombre solo salga una vez.
  Widget _buildContent(BuildContext context) {
    final filtrados = _filtrados;
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Incrementos',
                value: '$_totalIncrementos',
                subtitle: 'productos con alza de precio',
                valueColor: AppColors.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                title: 'Disminuciones',
                value: '$_totalDisminuciones',
                subtitle: 'productos con baja de precio',
                valueColor: AppColors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _FiltersCard(
          controller: _searchController,
          filtroTipo: _filtroTipo,
          onFiltroTipoChanged: (v) => setState(() => _filtroTipo = v),
          onBuscarChanged: (_) => setState(() {}),
          onLimpiar: () => setState(() {
            _searchController.clear();
            _filtroTipo = 'Todos';
          }),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            'Historial de Precios (${filtrados.length})',
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        for (final c in filtrados)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PriceChangeCard(cambio: c),
          ),
        if (filtrados.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                'No hay cambios de precio que coincidan con el filtro',
                style: TextStyle(color: AppColors.grayText, fontSize: 12.5),
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
      backgroundColor: AppColors.fondo,
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

// ==================== HEADER SUPERIOR (único lugar con el título) ====================
class _TopHeader extends StatelessWidget {
  final String userName;
  const _TopHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.encabezado,
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
              color: AppColors.dorado,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              'T4D',
              style: TextStyle(
                color: AppColors.encabezado,
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
                    color: AppColors.doradoClaro,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Historial de Precios',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
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
                  backgroundColor: AppColors.dorado,
                  child: const Icon(Icons.person, size: 11, color: AppColors.encabezado),
                ),
                const SizedBox(width: 5),
                Text(userName, style: const TextStyle(color: Colors.white, fontSize: 11.5)),
              ],
            ),
          ),
        ],
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dorado, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.doradoOscuro.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.grayText)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: valueColor)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 10.5, color: AppColors.grayText)),
        ],
      ),
    );
  }
}

// ==================== FILTROS ====================
class _FiltersCard extends StatelessWidget {
  final TextEditingController controller;
  final String filtroTipo;
  final ValueChanged<String> onFiltroTipoChanged;
  final ValueChanged<String> onBuscarChanged;
  final VoidCallback onLimpiar;

  const _FiltersCard({
    required this.controller,
    required this.filtroTipo,
    required this.onFiltroTipoChanged,
    required this.onBuscarChanged,
    required this.onLimpiar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dorado, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.filter_alt_outlined, size: 16, color: AppColors.dorado),
              SizedBox(width: 6),
              Text(
                'Filtros y Búsqueda',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            onChanged: onBuscarChanged,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Buscar por producto...',
              hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.grayText),
              prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.grayText),
              filled: true,
              fillColor: AppColors.fondo,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.doradoClaro),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.doradoClaro),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.dorado),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(label: 'Todos', selected: filtroTipo == 'Todos', onTap: () => onFiltroTipoChanged('Todos')),
              _Chip(
                label: 'Incremento',
                selected: filtroTipo == 'Incremento',
                onTap: () => onFiltroTipoChanged('Incremento'),
              ),
              _Chip(
                label: 'Disminución',
                selected: filtroTipo == 'Disminución',
                onTap: () => onFiltroTipoChanged('Disminución'),
              ),
              OutlinedButton.icon(
                onPressed: onLimpiar,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.encabezado,
                  side: const BorderSide(color: AppColors.doradoClaro),
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
      color: selected ? AppColors.dorado : AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? AppColors.dorado : AppColors.doradoClaro),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.encabezado : AppColors.grayText,
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== TARJETA DE CAMBIO DE PRECIO ====================
class _PriceChangeCard extends StatelessWidget {
  final PriceChangeRecord cambio;
  const _PriceChangeCard({required this.cambio});

  @override
  Widget build(BuildContext context) {
    final esIncremento = cambio.tipo == CambioTipo.incremento;
    final color = esIncremento ? AppColors.green : AppColors.red;
    final bg = esIncremento ? AppColors.greenBg : AppColors.redBg;
    final signo = esIncremento ? '+' : '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dorado, width: 1.2),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_fmtFecha(cambio.fecha), style: const TextStyle(fontSize: 11, color: AppColors.grayText)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(esIncremento ? Icons.arrow_upward : Icons.arrow_downward, size: 11, color: color),
                    const SizedBox(width: 3),
                    Text(
                      '$signo${cambio.porcentaje.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            cambio.producto,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Text(
                _fmtPrecio(cambio.precioAnterior),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.grayText,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.arrow_forward, size: 12, color: AppColors.grayText),
              ),
              Text(
                _fmtPrecio(cambio.precioNuevo),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Modificado por ${cambio.usuario}', style: const TextStyle(fontSize: 11, color: AppColors.grayText)),
        ],
      ),
    );
  }
}